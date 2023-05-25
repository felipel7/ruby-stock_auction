class ProductsController < ApplicationController
  include AuthorizationHelper

  before_action :authenticate_user!, except: [:index]
  before_action -> { check_admin_role(current_user) }, except: [:index]

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
      redirect_to admin_product_path(@product)
    else
      flash[:alert] = "Não foi possível cadastrar o produto"
      @categories = Category.all
      render :new
    end
  end

  def show
    @product = Product.find(params[:id])
  end
end
