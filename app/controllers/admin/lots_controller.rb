class Admin::LotsController < ApplicationController
  include AuthorizationHelper

  before_action :authenticate_user!
  before_action :set_lot, except: [:index, :new, :create]
  before_action -> { check_admin_role(current_user) }

  def index
    @lots = Lot.all
    @lots.where(status: :approved).each { |lot| lot.update_status }
    @lots = Lot.where(status: params[:status]) unless params[:status].nil?

    render :index
  end

  def show
  end

  def new
    @lot = Lot.new
  end

  def create
    @lot = Lot.new(lot_params)
    @lot.register_by_id = current_user.id

    if @lot.save
      flash[:notice] = "O lote foi cadastrado com sucesso."
      redirect_to admin_lot_path(@lot)
    else
      flash[:alert] = "Não foi possível cadastrar o lote."
      render :new
    end
  end

  def edit
  end

  def update
    if @lot.status != "pending"
      flash[:alert] = "Não é possível atualizar um lote durante essa fase."
      return redirect_to admin_lot_path(@lot)
    end

    if @lot.update(lot_params)
      flash[:notice] = "O lote foi atualizado com sucesso."
      redirect_to admin_lot_path(@lot)
    else
      flash.now[:alert] = "Não foi possível atualizar o lote."
      render :edit
    end
  end

  def manage
    @products = Product.where(lot_id: params[:id])
    @available_products = Product.where(lot_id: nil)
    render "manage"
  end

  def approved
    if @lot.status != "pending"
      flash.now[:alert] = "O lote já foi aprovado ou está finalizado."
      return render :show
    end

    @lot.approved_by = current_user

    if @lot.update(status: :approved)
      flash[:notice] = "O lote foi aprovado com sucesso."
      redirect_to admin_lot_path(@lot)
    else
      @lot.approved_by = nil
      @lot.reload
      flash.now[:alert] = "O lote não pode ser aprovado."
      render :show
    end
  end

  def add_product
    @products = Product.where(lot_id: params[:id])
    @available_products = Product.where(lot_id: nil)

    @product = Product.find(params[:product_id])

    if @lot.status == "pending"
      flash.now[:notice] = "O produto foi adicionado com sucesso."
      @lot.products << @product
      render "manage"
    else
      flash[:alert] = "Não é permitido adicionar um produto durante essa fase."
      render :show
    end
  end

  def remove_product
    @products = Product.where(lot_id: params[:id])
    @available_products = Product.where(lot_id: nil)

    @product = Product.find(params[:product_id])

    if @lot.status == "pending"
      flash.now[:notice] = "O produto foi removido com sucesso."
      @lot.products.delete(@product)
      render "manage"
    else
      flash[:alert] = "Não é permitido remover um produto durante essa fase."
      render :show
    end
  end

  def ended
    @status = params[:status]
    if @lot.bids.present?
      @winner = @lot.bids.last.user
    elsif @status == "canceled"
      @lot.products.destroy_all
    end

    if @lot.update(status: @status)
      flash[:notice] = "O lote foi atualizado com sucesso."
    else
      flash[:alert] = "#{@lot.errors&.full_messages[0]}"
    end
    redirect_to @lot
  end

  private

  def lot_params
    params.require(:lot).permit(:batch_code, :start_date, :end_date, :min_value, :min_allowed_difference, :photo)
  end

  def set_lot
    @lot = Lot.find(params[:id])
  end
end
