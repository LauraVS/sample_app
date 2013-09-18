require 'spec_helper'

describe "Static pages" do

  subject { page } #  the call to 'should' automatically uses the 'page' variable 

  # Home page ---------------------------------------------
  describe "Home page" do

    # antes de cada caso (it) se tiene que visitar root_path
    before { visit root_path }

    it { should have_content('Sample App') }
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }
  end

  # Help page ---------------------------------------------
  describe "Help page" do

    before { visit help_path }

    it { should have_content('Help') }
    it { should have_title(full_title('Help')) }
  end

  # About page ---------------------------------------------
  describe "About page" do

    before { visit about_path }

    it { should have_content('About Us') }
    it { should have_title(full_title('About Us')) }
  end

  # Contact page ---------------------------------------------
  describe "Contact page" do

    before { visit contact_path }

    it { should have_content('Contact') }
    it { should have_title(full_title('Contact')) }
  end
end