class UsersController < ApplicationController


  # -------------------------------
  # ----- BEFORE ACTION METHODS ---
  # -------------------------------  

  # Methods to be called before the given actions (are invoked using before_action):
  #    - signed_in_user--> method to require users to be signed in (for "edit", "update", "index")
  #    - correct_user--> A user should not have access to another user's edit or update actions
  #    - admin_user--> Restrict the destroy action to admins

  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  # By default, before filters apply to every action in a controller, 
  # so we can restrict the filter to act only on the :edit and :update 
  # actions by passing the appropriate :only options hash.



  # -------------------------------
  # ----- ACTION METHODS ----------
  # -------------------------------

  


  # Page to list all the users
  def index
    @users = User.paginate(page: params[:page])   # SELECT * FROM USER LIMIT 30 OFFSET 0
  end


  # Page to show a user
  def show
    @user = User.find(params[:id])
  end

  # -------------------------------
  # Page to make a new user (signup)
  def new
  	@user = User.new
  end

  # -------------------------------
  # Create a new user
  def create
    @user = User.new(user_params)  # user_params es variable privada

    if @user.save
      sign_in(@user) # Guardar el token del usuario (en BD y en una cookie)
      flash[:success] = "Welcome to the Sample App!" # Message to show in the page
      redirect_to @user
      # Eso redirecciona a la página de ver perfil de un usuario (show).
      # Se puede omitir la url. Es equivalente a: redirect_to user_path(@user)
    else
      render 'new'
      # Al haber errores de validación, continuamos en el formulario de creación
      # Los errores están en el propio objeto User: "user.errors.full_messages"
    end
  end


  # -------------------------------
  # Page to edit user
  def edit
    @user = User.find(params[:id])
  end


  # -------------------------------
  # Page to update user
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated" # Message to show in the page (see application.html.erb)
      redirect_to @user # Equivalente a: redirect_to user_path(@user)
    else
      render 'edit'
    end
  end


  # -------------------------------
  # Delete user
  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url    
  end



  # -------------------------------
  # ----- PRIVATE METHODS ---------
  # -------------------------------

  # All methods defined after private are automatically hidden to external users via the web.
  # They will only be used internally by the Users controller.
  private

	  def user_params
      # Recoge el parámetro "user" de la request
	  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
	  end


    # --- Before filters ------------

    def signed_in_user
      # Si no hay usuario autenticado, guardar la URL en sesión y redireccionar a la pág. de login
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end


    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end  


    def admin_user
      redirect_to(root_url) unless current_user.admin? # Redirect si campo admin==FALSE
    end    

end


# NOTA

# Esto:

#    def signed_in_user
#      redirect_to signin_url, notice: "Please sign in." unless signed_in?
#    end  

# Es equivalente a:

#   unless signed_in?
#    flash[:notice] = "Please sign in."
#    redirect_to signin_url
#   end 

#   (Unfortunately, the same construction doesn’t work for the :error or :success keys
#     Sí para :notice)     
