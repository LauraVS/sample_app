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

				it { should have_title(user.name) }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') } # have_selector to pick out particular CSS classes along with specific HTML tags.
			end			
	    end   	
	end


	# -----------------------------------------------------------------------------
	# Test página edición de un usuario -------------------------------------------
	# -----------------------------------------------------------------------------
	describe "profile page" do
		# create a User model object with Factory Girl
		let(:user) { FactoryGirl.create(:user) }

		# antes de cada caso (it) se tiene que visitar user_path(user)
		before { visit user_path(user) }

		it { should have_content(user.name) }
		it { should have_title(user.name) }

		# --- prueba para mostrar los campos del objeto user creado con FactoryGirl ---
		describe "print user data" do
	      it "should print the name, email, password" do
	      	puts user.name
	      	puts user.email
	      	puts user.password
	      end
	    end
	end

end
