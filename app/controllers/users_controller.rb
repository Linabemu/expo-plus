class UsersController < ApplicationController
  def index
    @users = User.all
  end


  def profile
    @user = User.find(params[:id])
    @followings = @user.followings.includes(:user)
    @followers = @user.followers.includes(:user)
    @wishes = @user.wishes.includes(:expo)
    @reviews = @user.reviews.includes(:expo)
    @proposals = @user.participations.includes(:expo)

    if params[:cookie].present?
      if params[:cookie] == "follow"
        Following.new(user_id: current_user.id, receiver_id: @user.id).save
      elsif params[:cookie] == "unfollow"
        current_user.followings.find_by(receiver_id: @user.id).destroy
      end
    end
  end
end
