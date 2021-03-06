require 'spec_helper'

describe "User pages" do

	subject { page } #  the call to 'should' automatically uses the 'page' variable	

	# -----------------------------------------------------------------------------
	# Test página de creación de nuevo usuario (SignUp) ---------------------------
	# -----------------------------------------------------------------------------
	describe "SignUp page" do

		# antes de cada caso (it) se tiene que visitar signup_path
		before { visit signup_path }

		let(:buttonText) { "Create my account" }	

		it { should have_content('Sign up') }
		it { should have_title(full_title('Sign up')) }


	    describe "with invalid information" do
			it "should not create a user" do
				expect { click_button buttonText }.not_to change(User, :count)
				# Equivalente a:
				#  initial = User.count
				#  click_button "Create my account"
				#  final = User.count
				#  expect(initial).to eq final
			end

			# Tests for the error messages 
			describe "after submission" do
				before { click_button buttonText }

				it { should have_title('Sign up') }
				it { should have_content('error') }
			end	      
	    end	


	    describe "with valid information" do

			before do
				# Rellenar los datos del formulario con valores
				# Los "fill_in" tienen que ir dentro de un bloque
				fill_in "Name",         with: "Example User"
				fill_in "Email",        with: "user@example.com"
				fill_in "Password",     with: "foobar"
				fill_in "Confirmation", with: "foobar"
			end 

			# Si los datos son válidos, al hacer el submit tiene que haber un usuario más
			it "should create a user" do
				expect { click_button buttonText }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before { click_button buttonText }
				let(:user) { User.find_by(email: 'user@example.com') }

				it { should have_link('Sign out') } # este submenú sólo se muestra si hay sesión iniciada
				it { should have_title(user.name) }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') } # have_selector to pick out particular CSS classes along with specific HTML tags.
			end			
	    end   	
	end


	# -----------------------------------------------------------------------------
	# Test página mostrar datos de un usuario -------------------------------------
	# -----------------------------------------------------------------------------
	describe "profile page" do
	    # Crear un usuario y microposts asociados a él
	    let(:user) { FactoryGirl.create(:user) }
	    let!(:m1) { FactoryGirl.create(:micropost, content:"Micropost_1", user: user) }
		let!(:m2) { FactoryGirl.create(:micropost, content:"Micropost_2", user: user) }

		# antes de cada caso (it) se tiene que visitar user_path(user)
		before { visit user_path(user) }

		it { should have_content(user.name) }
		it { should have_title(user.name) }

		# --- PRUEBA para mostrar los campos del objeto user creado con FactoryGirl ---
		describe "print user data" do
	      it "should print the name, email, password" do
	      	puts user.name
	      	puts user.email
	      	puts user.password
	      end
	    end
	    # --- FIN PRUEBA ---


		describe "microposts" do
			it { should have_content(m1.content) }
			it { should have_content(m2.content) }
			it { should have_content(user.microposts.count) }
		end


		# Botón Follow / Unfollow
		describe "follow/unfollow buttons" do

			let(:other_user) { FactoryGirl.create(:user) }
			before { sign_in user }

			# Follow
			describe "following a user" do

				before { visit user_path(other_user) }

				it "should increment the followed user count" do
					expect do
						click_button "Follow"
					end.to change(user.followed_users, :count).by(1)
				end

				it "should increment the other user's followers count" do
					expect do
						click_button "Follow"
					end.to change(other_user.followers, :count).by(1)
				end

				describe "toggling the button" do
					before { click_button "Follow" }
					# Trata al código HTML de la página como a un XML y comprueba que tenga ese elemento
					it { should have_xpath("//input[@value='Unfollow']") }
				end
			end

			# Unfollow
			describe "unfollowing a user" do

				before do
					user.follow!(other_user)
					visit user_path(other_user)
				end

				it "should decrement the followed user count" do
					expect do
						click_button "Unfollow"
					end.to change(user.followed_users, :count).by(-1)
				end

				it "should decrement the other user's followers count" do
					expect do
						click_button "Unfollow"
					end.to change(other_user.followers, :count).by(-1)
				end

				describe "toggling the button" do
					before { click_button "Unfollow" }
					it { should have_xpath("//input[@value='Follow']") }
				end
			end
		end

	end


	# -----------------------------------------------------------------------------
	# Test página edición de un usuario -------------------------------------------
	# -----------------------------------------------------------------------------
	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			sign_in user
			visit edit_user_path(user)
		end

		describe "page" do
		  it { should have_content("Update your profile") }
		  it { should have_title("Edit user") }
		  it { should have_link('change', href: 'http://gravatar.com/emails') }
		end

		
		describe "with invalid information" do
			# Tests for the error messages
			before { click_button "Save changes" }
			it { should have_content('error') }
		end


		describe "with valid information" do

			let(:new_name)  { "New Name" }
			let(:new_email) { "new@example.com" }

			before do
				fill_in "Name",             with: new_name
				fill_in "Email",            with: new_email
				fill_in "Password",         with: user.password
				fill_in "Confirmation",		with: user.password
				
				click_button "Save changes"
			end

			it { should have_title(new_name) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign out', href: signout_path) }

			specify { expect(user.reload.name).to  eq new_name }
			specify { expect(user.reload.email).to eq new_email }
		end

	end	


	# -----------------------------------------------------------------------------
	# Test página listado de usuarios ---------------------------------------------
	# -----------------------------------------------------------------------------
	describe "index - Named route = users_path" do

		# Crea usuarios, se valida con ellos y visita la página del listado
		let(:user) { FactoryGirl.create(:user) }
		before(:each) do # Antes de cada caso (it), se tiene que ejecutar el contenido de este bloque
			sign_in user
			visit users_path
		end

		it { should have_title('All users') }
		it { should have_content('All users') }

		describe "pagination" do

			before(:all) { 30.times { FactoryGirl.create(:user) } }  # Antes de todos los it, crear 30 usuarios
      		after(:all)  { User.delete_all }

      		it { should have_selector('div.pagination') }
			
			it "should list each user" do
				User.paginate(page: 1).each do |user|
					print " * "+ user.name
					expect(page).to have_selector('li', text: user.name)
				end	
			end
		end

		# Sólo usuarios administradores pueden borrar usuarios
		it { should_not have_link('delete') } 

		describe "as an admin user" do

			# Crear usuario admin, validarnos con él y visitar página del listado
			let(:admin) { FactoryGirl.create(:admin) }
			before do
				sign_in admin
				visit users_path
			end			
			
			it { should have_link('delete', href: user_path(User.first)) }
			it "should be able to delete another user" do
				expect do
					click_link('delete', match: :first) # clicka en el primer usuario que vea
				end.to change(User, :count).by(-1)
			end
			
			# El administrador no ve un enlace para borrarse a sí mismo
			it { should_not have_link('delete', href: user_path(admin)) }
		end

	end	


	# -----------------------------------------------------------------------------
	# Test listado de Following y Followers ---------------------------------------------
	# -----------------------------------------------------------------------------
	describe "following/followers" do

		let(:user) { FactoryGirl.create(:user) }
		let(:other_user) { FactoryGirl.create(:user) }
		before { user.follow!(other_user) }

		# Listado de los seguidos por el usuario
		describe "followed users" do
			before do
				sign_in user
				visit following_user_path(user)
			end

			it { should have_title(full_title('Following')) }
			it { should have_selector('h3', text: 'Following') }
			it { should have_link(other_user.name, href: user_path(other_user)) }
		end

		# Listado de los seguidores del usuario
		describe "followers" do
			before do
				sign_in other_user
				visit followers_user_path(other_user)
			end

			it { should have_title(full_title('Followers')) }
			it { should have_selector('h3', text: 'Followers') }
			it { should have_link(user.name, href: user_path(user)) }
		end

	end

end
