class ReviewsController < ApplicationController


  def new
    @review = Review.new
    @expo = Expo.find(params[:expo_id])
  end

  def create
    @expo = Expo.find(params[:expo_id])
    @review = Review.new(review_params)
    @review.user = current_user
    @review.expo = @expo

    respond_to do |format|
      if @review.save
        format.html { redirect_to expo_path(@expo) }
        format.json # Follow the classic Rails flow and look for a create.json view
      else
        format.html { render "expos/show", status: :unprocessable_entity }
        format.json # Follow the classic Rails flow and look for a create.json view
      end
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
