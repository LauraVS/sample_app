require 'spec_helper'

describe "User pages" do

	subject { page } #  the call to 'should' automatically uses the 'page' variable	

	# SingUp page ---------------------------------------------
	describe "SignUp page" do

		# antes de cada caso (it) se tiene que visitar signup_path
		before { visit signup_path }

		it { should have_content('Sign up') }
		it { should have_title(full_title('Sign up')) }
	end

end
