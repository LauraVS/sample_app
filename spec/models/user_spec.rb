require 'spec_helper'

# Test de validaciones de los campos de User

describe User do

	# antes de cada caso (it) se tiene que hacer esto:
	# creating a new @user instance variable using User.new and a valid initialization hash
	before do
    	@user = User.new(name: "Example User", email: "user@example.com",
                    	 password: "foobar", password_confirmation: "foobar")
	end

	# makes @user the default subject of the test example
	# the call to 'should' automatically uses the '@user' variable
	subject { @user }	


	# method respond_to?, which accepts a symbol and returns true if the object responds to the given method or attribute and false otherwise
	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:authenticate) }

	# password_digest --> es la contraseña encriptada, la que se guarda en BD.
	# password --> es el campo contraseña del formulario. No se guarda en BD.
	# password_confirmation --> es el campo Confirmar contraseña del formulario. No se guarda en BD.
	# authenticate --> método que compara una password encriptada con password_digest, para autenticar usuarios

	it { should be_valid }
	# Eso equivale a:
	#it "should be valid" do
	#  expect(@user).to be_valid
	#end	

	it { should_not be_admin }


	# --------------------------------------------------------
	# ---- Validaciones en campos ----

	describe "with admin attribute set to 'true'" do
		before do
			@user.save!
			@user.toggle!(:admin) # changes the admin attribute from false to true
		end
		it { should be_admin } # implies (via the RSpec boolean convention) that the user should have an admin? boolean method
	end	

	# Valida presencia del campo nombre
	describe "when name is not present" do
		before { @user.name = " " } # antes del it se tiene que dar que el name sea blanco
		it { should_not be_valid }
	end	

	# Valida presencia del campo email
	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	# Valida longitud nombre <= 51
	describe "when name is too long" do
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end

	# Valida que falle con varios emails con formato incorrecto
	describe "when email format is invalid" do
		it "should be invalid" do
		  addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
		  addresses.each do |invalid_address|
		    @user.email = invalid_address
		    expect(@user).not_to be_valid
		  end
		end
	end

	# Valida que no falle con varios emails con formato correcto
	describe "when email format is valid" do
		it "should be valid" do
		  addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
		  addresses.each do |valid_address|
		    @user.email = valid_address
		    expect(@user).to be_valid
		  end
		end
	end

	# Valida no emails repetidos
	describe "when email address is already taken" do
		before do
		  user_with_same_email = @user.dup # creates a duplicate user with the same attributes
		  user_with_same_email.email = @user.email.upcase
		  user_with_same_email.save # we save that user. Now there are 2 users with the same email
		end

		it { should_not be_valid }
	end

	# Valida que las passwords no estén en blanco
	describe "when password is not present" do
	  before do
	    @user = User.new(name: "Example User", email: "user@example.com",
	                     password: " ", password_confirmation: " ")
	  end
	  it { should_not be_valid }
	end	

	# Valida que password y password_confirmation sean iguales
	describe "when password doesn't match confirmation" do
	  before { @user.password_confirmation = "mismatch" }
	  it { should_not be_valid }
	end

	# Valida que password tenga al menos 6 caracteres
	describe "with a password that's too short" do
	  before { @user.password = @user.password_confirmation = "a" * 5 }
	  it { should be_invalid }
	end	

	# Autenticación
	describe "return value of authenticate method" do

		# Guarda el usuario en BD y lo recupera (en la variable found_user)
		before { @user.save }
		let(:found_user) { User.find_by(email: @user.email) }

		describe "with valid password" do
			# @user and found_user should be the same (password match)
			it { should eq found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			# @user and found_user should not be the same (password mismatch)
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }

			it { should_not eq user_for_invalid_password }
			specify { expect(user_for_invalid_password).to be_false }
		end
	end	

	# A test for a valid (nonblank) remember token
	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
		# Equivalente: it { expect(@user.remember_token).not_to be_blank }
	end


	it { should respond_to(:admin) }


	# --------------------------------------------------------
	# Test para validar las asociaciones de User con Micropost
	it { should respond_to(:microposts) }
	it { should respond_to(:feed) }

	describe "micropost associations" do

		before { @user.save }
		let!(:older_micropost) { FactoryGirl.create(:micropost, content:"older_micropost", user: @user, created_at: 1.day.ago) }
		let!(:newer_micropost) { FactoryGirl.create(:micropost, content:"newer_micropost", user: @user, created_at: 1.hour.ago) }

	    it "should have the right microposts in the right order" do
	      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
	    end

		# --- PRUEBA para mostrar los Microposts del User ---
		describe "Test print @user microposts" do
			let(:a) {@user.microposts.to_a}
			it "prints user's micoposts data" do
				# (Criterio de ordenación del array definido en "micropost.rb")
				puts "\n"
				puts "First Micropost -> id: " + a[0].id.to_s + ", created_at: " +  a[0].created_at.to_s + ", content: " + a[0].content 
				puts "Second Micropost -> id: " + a[1].id.to_s + ", created_at: " +  a[1].created_at.to_s + ", content: " + a[1].content 
			end
	    end
	    # --- FIN PRUEBA ---

		it "should destroy associated microposts" do
			microposts = @user.microposts.to_a
			@user.destroy
			expect(microposts).not_to be_empty
			microposts.each do |micropost|
				expect(Micropost.where(id: micropost.id)).to be_empty
			end
		end

		# Test feeds
		describe "status" do
			let(:unfollowed_post) { FactoryGirl.create(:micropost, user: FactoryGirl.create(:user)) }

			# El feed contiene los microposts del usuario, pero excluye los de otros usuarios
			its(:feed) { should include(newer_micropost) }
			its(:feed) { should include(older_micropost) }
			its(:feed) { should_not include(unfollowed_post) }
		end		


	end	

end