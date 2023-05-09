class CategoriesController < ApplicationController
  include AuthorizationHelper

  before_action -> { check_admin_role(current_user) }

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new()
  end

  def create
    category_params = params.require(:category).permit(:name)
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = "Categoria salva com sucesso"
      redirect_to categories_path
    else
      flash.now[:alert] = "Não foi possível salvar a categoria"
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    category_params = params.require(:category).permit(:name)
    @category = Category.find(params[:id])

    if @category.update(category_params)
      flash[:notice] = "Categoria foi atualizada com sucesso."
      redirect_to categories_path
    else
      flash.now[:alert] = "Não foi possível editar a categoria."
      render :edit
    end
  end
end
