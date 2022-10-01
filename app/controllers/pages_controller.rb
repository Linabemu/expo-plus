class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :index]
  before_action :set_expo, only: [:show]

  def home
    @expos = Expo.all
    @upcoming = @expos.select { |expo| expo.date_start > Date.today }
    @endend_soon = @expos.select { |expo| expo.date_start <= Date.today && (expo.date_end - Date.today).to_i < 15 }
    @best_rated = @expos.select { |expo| expo.average_rating && (expo.average_rating > 4) }
    session[:all_filter_params] = nil
  end

  private

  def set_expo
    @expo = Expo.find(params[:id])
  end
end
