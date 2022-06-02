class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  before_action :set_expo, only: [:show]

  def home
    @expos = Expo.all
    difference = []
    @expos.each do |expo|
      difference << (expo.date_start - Date.today) if expo.date_start > Date.today
    end
    @next_expos = difference.min(5)
  end

  private

  def set_expo
    @expo = Expo.find(params[:id])
  end
end
