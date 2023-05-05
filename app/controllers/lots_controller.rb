class LotsController < ApplicationController
  def index
    @lots = Lot.all
    @lots_approved = Lot.where(status: :approved)
  end

  def new
    @lot = Lot.new
  end

  def create
    @lot = Lot.create(lot_params)

    if @lot.save
      flash[:notice] = "Lote cadastrado com sucesso"
      redirect_to @lot
    else
      flash[:alert] = "Não foi possível cadastrar o lote"
      render :new
    end
  end

  def show
    @lot = Lot.find(params[:id])
  end

  private

  def lot_params
    params.require(:lot).permit(:start_date, :end_date, :min_value, :min_allowed_difference)
  end
end
