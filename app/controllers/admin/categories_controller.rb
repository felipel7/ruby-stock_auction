class Admin::CategoriesController < ApplicationController
  include AuthorizationHelper

  before_action -> { check_admin_role(current_user) }

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    category_params = params.require(:category).permit(:name)
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_categories_path, notice: t('categories.success.save')
    else
      flash.now[:alert] = t('categories.error.save')
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
      redirect_to admin_categories_path, notice: t('categories.success.update')
    else
      flash.now[:alert] = t('categories.error.update')
      render :edit
    end
  end
end
