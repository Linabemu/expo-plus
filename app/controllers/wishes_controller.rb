class WishesController < ApplicationController
  before_action :set_expo, only: [:create]

  def create
    @wish = Wish.new()
    @wish.expo = @expo
    @wish.user = current_user

    respond_to do |format|
      if Wish.find_by(user_id: @wish.user.id, expo_id: @wish.expo.id)
        destroy
        format.html { redirect_to request.referer }
        format.json
      else
        @wish.save
        format.html { redirect_to request.referer }
        format.json
      end
    end

  end

  def destroy
    @wish = Wish.find_by(user_id: current_user.id, expo_id: @expo.id)
    # authorize @booking
    @wish.destroy
    redirect_to request.referer
  end


  private

  # def wishes_params
  #   params.require(:wish).permit(:user_id, :expo_id)
  # end

  def set_expo
    @expo = Expo.find(params[:expo_id])
  end

end
