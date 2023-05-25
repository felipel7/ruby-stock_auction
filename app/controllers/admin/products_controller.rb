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
      flash[:notice] = "O produto foi cadastrado com sucesso"
      redirect_to @product
    else
      flash[:alert] = "Não foi possível cadastrar o produto"
      @categories = Category.all
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
      flash[:notice] = "O Produto foi salvo com sucesso."
      redirect_to @product
    else
      flash.now[:alert] = "Não foi possível salvar o produto"
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
