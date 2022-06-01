class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @expos = Expo.all
  end
end
