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
      flash[:notice] = "O Lote foi removido dos favoritos com sucesso."
      redirect_to root_path
    else
      @favorite = Favorite.new(user: current_user, lot: @lot)
      if @favorite.save
        flash[:notice] = "Lote foi adicionado aos favoritos."
        redirect_to favorites_path
      else
        flash[:alert] = "Erro ao adicionar produto aos favoritos."
        redirect_to root_path
      end
    end
  end

  private

  def check_admin
    if current_user.is_admin?
      flash[:alert] = "Admin não pode favoritar um lote."
      redirect_to root_path
    end
  end
end
