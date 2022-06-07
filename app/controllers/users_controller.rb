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
    @proposals = @user.proposals.includes(:expo) + @user.participations.includes(:expo)
  end

end
