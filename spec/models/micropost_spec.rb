require 'spec_helper'


# Test de validaciones de los campos de Micropost
# y de las asociaciones con User

describe Micropost do

	let(:user) { FactoryGirl.create(:user) }
	before { @micropost = user.microposts.build(content: "Lorem ipsum") }


	# makes @micropost the default subject of the test example
	# each call to 'should' automatically uses the '@micropost' variable
	subject { @micropost }

	# Comprobar que el objeto (@micropost) responde a los siguientes atributos
	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	its(:user) { should eq user }

	it { should be_valid }


	# --------------------------------------------------------
	# ---- Validaciones en campos ----	

	describe "when user_id is not present" do
		before { @micropost.user_id = nil }
		it { should_not be_valid }
	end

	describe "with blank content" do
		before { @micropost.content = " " }
		it { should_not be_valid }
	end

	describe "with content that is too long" do
		before { @micropost.content = "a" * 141 } # Valida longitud nombre <= 141
		it { should_not be_valid }
	end
end
