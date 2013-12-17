class User < ActiveRecord::Base
	
	has_many(:microposts, dependent: :destroy)

	before_save { self.email = email.downcase }
	validates(:name,  presence: true, length: { maximum: 50 })
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false })

	has_secure_password
	validates :password, length: { minimum: 6 }

	# create a remember token immediately before creating a new user in the database
	before_create :create_remember_token
	# This code, called a method reference, arranges for Rails to look for a method 
	# called create_remember_token and run it before saving the user. 




	# Public methods

	# It returns a random string of length 16 in Base64 encoding 
	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end


	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def feed
		# This is preliminary. See "Following users" for the full implementation.
		Micropost.where("user_id = ?", id)
	end	



	# ---
	# All methods defined after private are automatically hidden to external users via the web.
	# They will only be used internally by the Users model.
	private

	    def create_remember_token
	      # Con "self" accedemos a la vble "remember_token" del modelo, la de BD
	      self.remember_token = User.encrypt(User.new_remember_token)
	    end    	
end
