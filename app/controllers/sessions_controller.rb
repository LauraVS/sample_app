class SessionsController < ApplicationController

  def new
  end


  def create

  	user = User.find_by(email: params[:session][:email].downcase)	

   	if user && user.authenticate(params[:session][:password]) 
      # "authenticate" encripta una password y la compara con la password_digest de BD

      sign_in(user)

      # Redirecciona a la url guardada. Si no existe, redirecciona a la página de ver un usuario
      redirect_back_or(user_path(user))
      # Ej: redirect_to user --> Equivalente a: redirect_to user_path(user)

   	else
   		# Create an error message and re-render the signin form
  		flash.now[:error] = 'Invalid email/password combination'
  		render 'new'
   	end
  end


  def destroy
    sign_out
    redirect_to root_url    
  end

end
