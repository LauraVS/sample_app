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
      sign_in(@user) # Guardar el token del usuario (en BD y en una cookie)
      flash[:success] = "Welcome to the Sample App!" # Message to show in the page
      redirect_to @user
      # Eso redirecciona a la página de edición de un usuario.
      # Se puede omitir la url. Es equivalente a: redirect_to user_path(@user)
    else
      render 'new'

      # Al haber errores de validación, continuamos en el formulario de creación
      # Los errores están en el propio objeto User: "user.errors.full_messages"
    end
  end



  # ---
  # All methods defined after private are automatically hidden to external users via the web.
  # They will only be used internally by the Users controller.
  private

	  def user_params
	  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
	  end

end
