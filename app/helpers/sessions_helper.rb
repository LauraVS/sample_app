module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token # crea un nuevo token
    cookies.permanent[:remember_token] = remember_token # lo guarda en una cookie
    user.update_attribute(:remember_token, User.encrypt(remember_token)) # lo guarda encriptado en BD
    self.current_user = user # Eq: self.current_user=(user)
  end


  def signed_in?
    # A user is signed in if there is a current user in the session.
    # (Se llama al getter)
    !current_user.nil?
  end  


  # Setter
  def current_user=(user)
    @current_user = user
  end 


  # Getter 
  def current_user
  	# Se encripta el token almacenado en la cookie del navegador
    remember_token = User.encrypt(cookies[:remember_token])

    # Se busca el usuario en BD a partir de ese token encriptado (sólo si @current_user es undefined)
    @current_user ||= User.find_by(remember_token: remember_token) 

    # ||= calls the find_by method the first time current_user is 
    # called, but on subsequent invocations returns @current_user 
    # without hitting the database
  end


  def current_user?(user)
    user == current_user
  end


  def signed_in_user
    # Si no hay usuario autenticado, guardar la URL en sesión y redireccionar a la pág. de login
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end  


  def sign_out
    self.current_user = nil  # Eq: self.current_user=(nil)
    cookies.delete(:remember_token)
  end 


  def redirect_back_or(default)

    if session[:return_to] != nil
      logger.info "\n\n******** Redirecciona a la url en session: " + session[:return_to]
    else
      logger.info "\n\n******** Redirecciona a: " +default
    end

    # Redirect to the stored location
    redirect_to(session[:return_to] || default)  # si es nula la url en sesión, va a por defecto
    session.delete(:return_to)
  end


  def store_location
    # Store the request url in session, only for GET request
    session[:return_to] = request.url if request.get?
  end

end
