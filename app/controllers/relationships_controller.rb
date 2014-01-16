class RelationshipsController < ApplicationController

  # -------------------------------
  # ----- BEFORE ACTION METHODS ---
  # -------------------------------  
  before_action :signed_in_user



  # -------------------------------
  # ----- ACTION METHODS ----------
  # -------------------------------

  # Create relationship
  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)

    # responding to Ajax requests
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end


  # -------------------------------
  # Delete relationship
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)

    # responding to Ajax requests
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end    
  end
  
end