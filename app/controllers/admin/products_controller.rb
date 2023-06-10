class Admin::ProductsController < ApplicationController
  include AuthorizationHelper

  before_action :authenticate_user!
  before_action -> { check_admin_role(current_user) }

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    @product = Product.new(products_params)

    if @product.save
      redirect_to @product, notice: t('products.success.save')
    else
      @categories = Category.all
      flash[:alert] = t('products.error.save')
      render :new
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
    @product = Product.find(params[:id])
    @categories = Category.all
  end

  def update
    @product = Product.find(params[:id])
    @categories = Category.all

    if @product.update(products_params)
      redirect_to @product, notice: t('products.success.update')
    else
      flash.now[:alert] = t('products.error.update')
      render :edit
    end
  end

  private

  def products_params
    params.require(:product).permit(
      :name,
      :description,
      :height,
      :width,
      :depth,
      :weight,
      :category_id,
      :photo
    )
  end
end
