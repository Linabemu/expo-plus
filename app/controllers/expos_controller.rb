class ExposController < ApplicationController
  def index
    @expos = Expo.all
  end

  def show
  end
end
