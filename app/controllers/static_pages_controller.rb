class StaticPagesController < ApplicationController



  # -------------------------------
  # ----- ACTION METHODS ----------
  # -------------------------------


  def home
    if signed_in?
    	# En el caso de que hay un usuario en sesión, hay que crear un objeto @micropost
    	# para el usuario, de modo que se puedan crear microposts en el formulario
    	@micropost = current_user.microposts.build

      # Microposts del usuario en sesión
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end


  def help
  end


  def about
  end


  def contact
  end  
end
