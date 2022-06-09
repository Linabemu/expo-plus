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
      @queries = @expos.all.map(&:tags).flatten

    elsif params[:filters].present?
      @expos = Expo.where("tags && ARRAY[?]::varchar[]", params[:filters][:categories])
      @queries = params[:filters][:categories]
    elsif session[:current_expo_id].present?
      @expos = Expo.where(id: session[:current_expo_id])
    else
    # elsif params[:commit].present?
    # @expos = policy_scope(Expo.where('category ILIKE ?', "%#{params[:commit]}"))
    # else
    # @expos = policy_scope(Expo)
      @expos = Expo.all
      @queries = ['Toutes les meilleures expos']
    end
    # end
    @all_filter_params = all_filter_params
    session[:all_filter_params] = all_filter_params

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
    session[:current_expo_id] = @expo.id
  end

  def display_filters
    params[:query]
  end

  # def carrousel_title(el)
  #   if el.title.count > 10
  #     mots = el.split
  #     el = "#{mots[O]}\n#{mots.slice(1..-1)}"
  #   else
  #     el = title.title
  #   end
  #   return el
  # end

  private

  def all_filter_params
    return {} unless params[:filters].present?

    {
      filters: params.require(:filters).permit(categories: [], price_type: []),
      query: params.permit(:query)
    }
  end

  def set_expo
    @expo = Expo.find(params[:id])
  end

end
