class FavoritesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :create]
  before_action :check_admin, only: [:create]

  def index
    @favorite_lots = Lot.joins(:favorites).where(favorites: { user_id: current_user.id })
    favorite_lot_ids = @favorite_lots.pluck(:id)

    @recommended_lots = Lot.where(status: :ended).where.not(id: favorite_lot_ids)
  end

  def create
    @lot = Lot.find(params[:lot_id])
    @favorite = current_user&.favorites.find_by(lot: @lot)

    if @favorite
      @favorite.destroy
      redirect_to root_path, notice: t('favorites.warning.save')
    else
      @favorite = Favorite.new(user: current_user, lot: @lot)
      if @favorite.save
        redirect_to favorites_path, notice: t('favorites.success.save')
      else
        flash[:alert] = t('favorites.error.save')
        redirect_to root_path
      end
    end
  end

  private

  def check_admin
    if current_user.is_admin?
      flash[:warning] = t('favorites.warning.admin_save')
      redirect_to root_path
    end
  end
end
