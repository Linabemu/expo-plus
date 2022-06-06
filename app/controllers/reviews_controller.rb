class ReviewsController < ApplicationController


  def new
    @review = Review.new
    @expo = Expo.find(params[:expo_id])
  end

  def create
    @review = Review.new(review_params)
    @expo = Expo.find(params[:expo_id])
    @review.user = current_user
    @review.expo = @expo
    if @review.save
      redirect_to expo_path(@expo)
    else
      render 'expos/show', status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def set_expo
    @expo = Expo.find(params[:expo_id])
  end
end
