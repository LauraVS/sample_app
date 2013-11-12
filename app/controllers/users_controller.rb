class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end
  
  def create
    @user = User.new(user_params)  # user_params es variable privada

    if @user.save
      flash[:success] = "Welcome to the Sample App!" # Message to show in the page
      redirect_to @user
      # Eso redirecciona a la página de edición de un usuario.
      # Se puede omitir la url. Es equivalente a: redirect_to user_path(@user)
    else
      render 'new'
    end
  end


  # Variables privadas de la clase
  private

	  def user_params
	  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
	  end

end
