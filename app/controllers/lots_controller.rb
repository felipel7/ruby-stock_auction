class LotsController < ApplicationController
  include AuthorizationHelper

  before_action :authenticate_user!, except: [:index]
  before_action -> { check_admin_role(current_user) }, except: [:index]

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

  def edit
    @lot = Lot.find(params[:id])
  end

  def update
  end

  def approved
    @lot = Lot.find(params[:id])
    @lot.approved_by_id = current_user.id

    if @lot.update(status: :approved)
      flash[:notice] = "Status do Lote foi atualizado com sucesso"
    else
      flash[:alert] = "Não foi possível atualizar o status do Lote"
    end
    redirect_to @lot
  end

  def inactive
    @lot = Lot.find(params[:id])

    if @lot.update(status: :inactive)
      flash[:notice] = "Status do Lote foi atualizado com sucesso"
    else
      flash[:alert] = "Não foi possível atualizar o status do Lote"
    end
    redirect_to @lot
  end

  def lot_params
    params.require(:lot).permit(
      :start_date, :end_date, :min_value, :min_allowed_difference
    ).merge(register_by_id: current_user.id)
  end
end
