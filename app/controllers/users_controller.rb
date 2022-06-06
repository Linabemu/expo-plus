class UsersController < ApplicationController
  def index
    @users = User.all
  end


  def profile
    @user = current_user
    @followings = @user.followings.includes(:user)
    @followers = @user.followers.includes(:user)
    @wishes = @user.wishes.includes(:expo)
    @reviews = @user.reviews.includes(:expo)
    @proposals = @user.proposals.includes(:expo)
    @participations = @user.participations.includes(:proposal, :expo)

  end
end
