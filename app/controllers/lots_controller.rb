class LotsController < ApplicationController
  include AuthorizationHelper

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_lot, except: [:index, :new, :create]
  before_action -> { check_admin_role(current_user) }, except: [:index, :show]

  def index
    @lots = Lot.all

    if current_user&.is_admin?
      render "lots/admin/index"
    end
  end

  def new
    @lot = Lot.new
  end

  def create
    @lot = Lot.create(lot_params)

    if @lot.save
      flash[:notice] = "O lote foi cadastrado com sucesso."
      redirect_to @lot
    else
      flash[:alert] = "Não foi possível cadastrar o lote."
      render :new
    end
  end

  def show
    total_bids_amount = @lot.bids.sum(:amount) || 0
    @current_bid = total_bids_amount.to_i + @lot.min_value.to_i

    render "lots/admin/show" if current_user&.is_admin?
  end

  def edit; end

  def update
    if @lot.status != "pending"
      flash[:alert] = "Não é possível atualizar um lote durante essa fase."
      return redirect_to @lot
    end

    if @lot.update(lot_params)
      flash[:notice] = "O lote foi atualizado com sucesso."
      redirect_to @lot
    else
      flash.now[:alert] = "Não foi possível atualizar o lote."
      render :edit
    end
  end

  def manage
    @products = ProductModel.where(lot_id: params[:id])
    @available_products = ProductModel.where(lot_id: nil)
    render "lots/admin/manage"
  end

  def approved
    if @lot.status != "pending"
      flash.now[:alert] = "O lote já foi aprovado ou está finalizado."
      return render "lots/admin/show"
    end

    @lot.approved_by = current_user

    if @lot.update(status: :approved)
      flash[:notice] = "O lote foi aprovado com sucesso."
      redirect_to @lot
    else
      @lot.approved_by = nil
      @lot.reload
      flash.now[:alert] = "O lote não pode ser aprovado."
      render "lots/admin/show"
    end
  end

  def add_product
    @products = ProductModel.where(lot_id: params[:id])
    @available_products = ProductModel.where(lot_id: nil)

    @product = ProductModel.find(params[:product_model_id])

    if @lot.status == "pending"
      flash.now[:notice] = "O produto foi adicionado com sucesso."
      @lot.product_models << @product
      render "lots/admin/manage"
    else
      flash[:alert] = "Não é permitido adicionar um produto durante essa fase."
      render "lots/admin/show"
    end
  end

  def remove_product
    @products = ProductModel.where(lot_id: params[:id])
    @available_products = ProductModel.where(lot_id: nil)

    @product = ProductModel.find(params[:product_model_id])

    if @lot.status == "pending"
      flash.now[:notice] = "O produto foi removido com sucesso."
      @lot.product_models.delete(@product)
      render "lots/admin/manage"
    else
      flash[:alert] = "Não é permitido remover um produto durante essa fase."
      render "lots/admin/show"
    end
  end

  private

  def lot_params
    params.require(:lot).permit(
      :start_date, :end_date, :min_value, :min_allowed_difference
    ).merge(register_by_id: current_user.id)
  end

  def set_lot
    @lot = Lot.find(params[:id])
  end
end
