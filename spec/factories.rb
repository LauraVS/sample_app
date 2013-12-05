FactoryGirl.define do




  # A factory to simulate User model objects. 
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    # Esta es una factoría de usuarios administradores
    factory :admin do
      admin true
    end    
  end  

  # Here "sequence" takes a symbol corresponding to the desired attribute (such as :name) 
  # and a block with one variable, which we have called "n". 
  # Upon successive invocations of the FactoryGirl method [FactoryGirl.create(:user)],
  # the block variable "n" is automatically incremented


=begin
  factory :user do
    name     "Michael Hartl"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
=end

end