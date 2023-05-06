class ProductModelsController < ApplicationController
  include AuthorizationHelper

  before_action :authenticate_user!
  before_action -> { check_admin_role(current_user) }

  def index
    @product_models = ProductModel.all
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
      :category_id
    )
  end
end
