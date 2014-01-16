require 'spec_helper'

describe Relationship do

	let(:follower) { FactoryGirl.create(:user) }
	let(:followed) { FactoryGirl.create(:user) }
	let(:relationship) { follower.relationships.build(followed_id: followed.id) }


	# makes 'relationship' the default subject of the test example
	# each call to 'should' automatically uses the 'relationship' variable
	subject { relationship }

	it { should be_valid }

	describe "follower methods" do
		it { should respond_to(:follower) }
		it { should respond_to(:followed) }
		its(:follower) { should eq follower }
		its(:followed) { should eq followed }
	end	


	# --------------------------------------------------------
	# ---- Validaciones en campos ----

	describe "when followed id is not present" do
		before { relationship.followed_id = nil }
		it { should_not be_valid }
	end

	describe "when follower id is not present" do
		before { relationship.follower_id = nil }
		it { should_not be_valid }
	end	

end
