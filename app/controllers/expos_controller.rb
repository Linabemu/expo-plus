class ExposController < ApplicationController
  before_action :set_expo, only: [:show]
  # skip_before_action :authenticate_user!, only: [:index, :show]bn

  def index


    # pour la search et les filtres on peut voir pour utiliser les formules ci-dessous mais en discuter avec Cyril si besoin car certaines ne fonctionneront pas forcément comme tel
    # ---------
    if params[:query].present? && params[:query] != nil
      sql_query = <<~SQL
        expos.title ILIKE :mot
        OR expos.description ILIKE :mot
      SQL
      @expos = Expo.where(sql_query, mot: "%#{params[:query]}%")
    # elsif params[:filters].present?
    #   @expos = Expo.where(tags: params[:filters][:categories])
    else
    # elsif params[:commit].present?
    #   @expos = policy_scope(Expo.where('category ILIKE ?', "%#{params[:commit]}"))
    # else
    #   @expos = policy_scope(Expo)
      @expos = Expo.all
    end
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
