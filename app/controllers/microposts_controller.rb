class MicropostsController < ApplicationController


  # -------------------------------
  # ----- BEFORE ACTION METHODS ---
  # -------------------------------

  # Methods to be called before the given actions (are invoked using before_action):
  #    - signed_in_user--> method to require users to be signed in
  #    - correct_user--> Restrict the destroy action to current_user

  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy




  # -------------------------------
  # ----- ACTION METHODS ----------
  # -------------------------------


  # -------------------------------
  # Create a new micropost
  def create
    @micropost = current_user.microposts.build(micropost_params)

    if @micropost.save
      flash[:success] = "Micropost created!"  # Message to show in the page
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
      # Hubo errores de validación, continuamos en la home
      # (hay que pasar la variable "@feed_items" para que la vista no falle)
    end
  end


  # -------------------------------
  # Delete micropost
  def destroy
    @micropost.destroy
    redirect_to root_url
  end




  # -------------------------------
  # ----- PRIVATE METHODS ---------
  # -------------------------------

  private

	  def micropost_params
	  	# Recoge el parámetro "micropost" de la request
	  	params.require(:micropost).permit(:content)
	  end


    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to(root_url) if @micropost.nil?
      # (for security purposes it is a good practice always to run lookups through the association)
    end

end