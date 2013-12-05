require 'spec_helper'

describe "Authentication" do

	subject { page } #  the call to 'should' automatically uses the 'page' variable

	# -----------------------------------------------------------------------------
	# Test para la autenticación de un usuario (SignIn) ---------------------------
	# -----------------------------------------------------------------------------
	describe "SignIn page" do

		# antes de cada caso (it) se tiene que visitar signin_path
		before { visit signin_path }

		let(:buttonSignInText) { "Sign in" }
		let(:buttonSignOutText) { "Sign out" }

		it { should have_content('Sign in') }
		it { should have_title(full_title('Sign in')) }


		describe "with invalid information" do
			before { click_button buttonSignInText }

			it { should have_content('Sign in') }
			# Tests for the error messages			
			it { should have_selector('div.alert.alert-error', text: 'Invalid') } # have_selector to pick out particular CSS classes along with specific HTML tags.

			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end			
		end


		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before { sign_in user }

			describe "after doing the sign in" do
				it { should have_title(user.name) }
				it { should have_link('Users',       href: users_path) }
				it { should have_link('Profile',     href: user_path(user)) }
				it { should have_link('Settings',    href: edit_user_path(user)) }
				it { should have_link('Sign out',    href: signout_path) }
				it { should_not have_link('Sign in', href: signin_path) }
			end

			describe "followed by signout" do
				before { click_link buttonSignOutText }
				it { should have_link(buttonSignInText) }
			end				
		end		

	end


	# -----------------------------------------------------------------------------
	# Test de acceso a las acciones "edit" y "update" -----------------------------
	# -----------------------------------------------------------------------------	
	describe "authorization" do

		describe "for non-signed-in users" do

			let(:user) { FactoryGirl.create(:user) }

			# Test de que las acciones "edit" y "update" están protegidas a usuarios validados
			describe "edit and update in the Users controller" do

				describe "visiting the edit page" do
					# Vamos a "edit", pero la página resultante contiene "Sign in", es 
					# decir,nos ha redireccionado a la página de "Sign in", porque
					# aún no nos hemos valiado
					before { visit edit_user_path(user) }
					it { should have_title('Sign in') }
				end

				describe "submitting to the update action" do
					before { patch user_path(user) } 
					# Second way, apart from Capybara’s visit method, to access a controller
					# action (in addition to patch Rails tests support get, post and delete
					# as well).
					# This is necessary because there is no way for a browser to visit 
					# the update action directly

					specify { expect(response).to redirect_to(signin_path) } 
					# Verify that the update action responds by redirecting to the signin page
				end
			end


			# Si no estamos validados e intentamos acceder a la página de edición, nos
			# redirecciona a la página de Sig in. Si ahí nos validamos, lo lógico es
			# que después se muestre la página de edición
			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path(user)
					fill_in "Email",    with: user.email
					fill_in "Password", with: user.password
					click_button "Sign in"
				end

				describe "after signing in" do
					it "should render the desired protected page" do
						expect(page).to have_title('Edit user')
					end
				end
			end	


			# Test de que la acción "index" está protegida
			describe "index action in the Users controller" do

				describe "visiting the user index (page to list all users)" do
					before { visit users_path }
					it { should have_title('Sign in') } # Como aún no nos hemos validado, vamos al SigIn
				end
			end	
		end


		# Test de que un usuario sólo puede hacer edit y update de su propia información
		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }

			before { sign_in user, no_capybara: true }

			describe "submitting a GET request to the Users#edit action" do
				before { get edit_user_path(wrong_user) }
				specify { expect(response.body).not_to match(full_title('Edit user')) }
				specify { expect(response).to redirect_to(root_url) }
			end

			describe "submitting a PATCH request to the Users#update action" do
				before { patch user_path(wrong_user) }
				specify { expect(response).to redirect_to(root_url) }
			end
		end	


		# Test de que usuarios no administradores no puedan borrar usuarios
		describe "as non-admin user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }

			before { sign_in non_admin, no_capybara: true }

			describe "submitting a DELETE request to the Users#destroy action" do
				before { delete user_path(user) }
				specify { expect(response).to redirect_to(root_url) }
				# Si un no admin intenta borrar, hay que redirigir a la pág. de inicio
			end
		end
		
	end


end
