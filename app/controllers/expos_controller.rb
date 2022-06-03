class ExposController < ApplicationController
  before_action :set_expo, only: [:show]
  # skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @expos = Expo.all
    @expos = @expos.where(tags: params[:filters][:categories]) if params[:filters].present?

    ####
    # @tags = [params[:filters][:categories]]

    # @expos = @expos.map do |expo|
    #   expo unless (expo.tags & @tags).empty?
    # end
    ###

    # pour la search et les filtres on peut voir pour utiliser les formules ci-dessous mais en discuter avec Cyril si besoin car certaines ne fonctionneront pas forcément comme tel
    # ---------
    # if params[:query].present? && params[:query] != nil
    #   @expos = policy_scope(Expo.where('name ILIKE ?', "%#{params[:query]}"))
    # elsif params[:commit].present?
    #   @expos = policy_scope(Expo.where('category ILIKE ?', "%#{params[:commit]}"))
    # else
    #   @expos = policy_scope(Expo)
    # end
  end

  def show
    @review = Review.new()
    @reviews = @expo.reviews
    @proposals = @expo.proposals
  end

  private

  def set_expo
    @expo = Expo.find(params[:id])
  end
end
