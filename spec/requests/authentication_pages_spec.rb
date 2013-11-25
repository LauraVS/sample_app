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
			before do
				fill_in "Email",    with: user.email.upcase
				fill_in "Password", with: user.password
				click_button buttonSignInText
			end 

			describe "after doing the sign in" do
				it { should have_title(user.name) }
				it { should have_link('Profile',     href: user_path(user)) }
				it { should have_link('Sign out',    href: signout_path) }
				it { should_not have_link('Sign in', href: signin_path) }
			end

			describe "followed by signout" do
				before { click_link buttonSignOutText }
				it { should have_link(buttonSignInText) }
			end				
		end		

	end

end
