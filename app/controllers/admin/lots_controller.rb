class Admin::LotsController < ApplicationController
  include AuthorizationHelper

  before_action -> { check_admin_role(current_user) }
  before_action :authenticate_user!
  before_action :set_lot, only: %i[
    show edit update approved manage
    add_product remove_product ended
  ]

  def index
    @lots = Lot.all
    @lots.where(status: :approved).each(&:update_status)
    @lots = Lot.where(status: params[:status]) unless params[:status].nil?

    render :index
  end

  def show; end

  def new
    @lot = Lot.new
  end

  def edit; end

  def create
    @lot = Lot.new(lot_params)
    @lot.register_by_id = current_user.id

    if @lot.save
      redirect_to admin_lot_path(@lot), notice: t('lot.success.save')
    else
      flash[:alert] = t('lot.error.save')
      render :new
    end
  end

  def update
    return redirect_to admin_lot_path(@lot), alert: t('lot.error.update_not_allowed') if @lot.status != 'pending'

    if @lot.update(lot_params)
      flash[:notice] = t('lot.success.update')
      redirect_to admin_lot_path(@lot)
    else
      flash.now[:alert] = t('lot.error.update')
      render :edit
    end
  end

  def manage
    @products = Product.where(lot_id: params[:id])
    @available_products = Product.where(lot_id: nil)
    render 'manage'
  end

  def approved
    if @lot.status != 'pending'
      flash.now[:alert] = t('lot.error.lot_approved_or_finalized')
      return render :show
    end

    @lot.approved_by = current_user

    if @lot.update(status: :approved)
      redirect_to admin_lot_path(@lot), notice: t('lot.success.approved')
    else
      @lot.approved_by = nil
      @lot.reload
      flash.now[:alert] = t('lot.error.approved')
      render :show
    end
  end

  def add_product
    @products = Product.where(lot_id: params[:id])
    @available_products = Product.where(lot_id: nil)

    @product = Product.find(params[:product_id])

    if @lot.status == 'pending'
      flash.now[:notice] = t('lot.success.add_product')
      @lot.products << @product
      render 'manage'
    else
      render :show, alert: t('lot.error.add_product')
    end
  end

  def remove_product
    @products = Product.where(lot_id: params[:id])
    @available_products = Product.where(lot_id: nil)
    @product = Product.find(params[:product_id])

    if @lot.status == 'pending'
      flash.now[:notice] = t('lot.success.remove_product')
      @lot.products.delete(@product)
      render 'manage'
    else
      render :show, alert: t('lot.error.remove_product')
    end
  end

  def ended
    @status = params[:status]
    if @lot.bids.present?
      @winner = @lot.bids.last.user
    elsif @status == 'canceled'
      @lot.products.destroy_all
    end

    if @lot.update(status: @status)
      flash[:notice] = t('lot.success.update')
    else
      flash[:alert] = @lot.errors&.full_messages[0].to_s
    end
    redirect_to admin_lot_path(@lot)
  end

  private

  def lot_params
    params.require(:lot).permit(:batch_code, :start_date, :end_date, :min_value, :min_allowed_difference, :photo)
  end

  def set_lot
    @lot = Lot.find(params[:id])
  end
end
