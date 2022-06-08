class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :index]
  before_action :set_expo, only: [:show]

  def home
    @expos = Expo.all
    @upcoming = []
    @endend_soon = []

    @expos.each do |expo|
      @upcoming << expo if expo.date_start > Date.today
      @endend_soon << expo if expo.date_start <= Date.today && (expo.date_end - Date.today).to_i < 15
    end

    @best_rated = []
    expositions = Expo.includes(:reviews).all
    expositions.each do |expo|
      @best_rated << expo if  expo.average_rating && (expo.average_rating > 7)
    end
    session[:all_filter_params] = nil
  end

  private

  def set_expo
    @expo = Expo.find(params[:id])
  end
end
