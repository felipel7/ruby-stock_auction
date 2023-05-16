class ProductModelsController < ApplicationController
  include AuthorizationHelper

  before_action :authenticate_user!, except: [:index]
  before_action -> { check_admin_role(current_user) }, except: [:index]

  def index
    @product_models = ProductModel.all

    if current_user&.is_admin?
      render "product_models/admin/index"
    end
  end

  def new
    @product_model = ProductModel.new
    @categories = Category.all
  end

  def create
    @product_model = ProductModel.new(product_models_params)

    if @product_model.save
      flash[:notice] = "O produto foi cadastrado com sucesso"
      redirect_to @product_model
    else
      flash[:alert] = "Não foi possível cadastrar o produto"
      @categories = Category.all
      render :new
    end
  end

  def show
    @product_model = ProductModel.find(params[:id])
  end

  private

  def product_models_params
    params.require(:product_model).permit(
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
