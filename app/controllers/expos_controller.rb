class ExposController < ApplicationController
  before_action :set_expo, only: [:show]
  # skip_before_action :authenticate_user!, only: [:index, :show]bn

  def index
    # @expos = Expo.all
    # @expos = @expos.where(tags: params[:filters][:categories]) if params[:filters].present?

    ####
    # @tags = [params[:filters][:categories]]

    # @expos = @expos.map do |expo|
    #   expo unless (expo.tags & @tags).empty?
    # end
    ###
    # pour la search et les filtres on peut voir pour utiliser les formules ci-dessous mais en discuter avec Cyril si besoin car certaines ne fonctionneront pas forcément comme tel
    # ---------
    if params[:query].present? && params[:query] != nil

      # sql_query = <<~SQL
      #   expos.title ILIKE :mot
      #   OR expos.description ILIKE :mot
      # SQL
      # @expos = Expo.where(sql_query, mot: "%#{params[:query]}%")
      @expos = Expo.global_search(params["query"])

    elsif params[:filters].present?
      @expos = Expo.where("tags && ARRAY[?]::varchar[]", params[:filters][:categories])
      @queries = params[:filters][:categories]
    else
    # elsif params[:commit].present?
    # @expos = policy_scope(Expo.where('category ILIKE ?', "%#{params[:commit]}"))
    # else
    # @expos = policy_scope(Expo)
      @expos = Expo.all
      @queries = ['Toutes les meilleures expos']
    end
    # end

    @markers = @expos.map do |expo|
      {
        lat: expo.place.lat,
        lng: expo.place.lon,
        info_window: render_to_string(partial: "info_window", locals: { expo: expo }),
        image_url: helpers.asset_url("pin_map.png"),
        id: expo.id
      }
    end
  end

  def show
    @review = Review.new()
    @reviews = @expo.reviews
    @proposals = @expo.proposals
  end

  def display_filters
    params[:query]
  end

  private

  def set_expo
    @expo = Expo.find(params[:id])
  end
end
