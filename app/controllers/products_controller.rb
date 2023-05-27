class ProductsController < ApplicationController
  include AuthorizationHelper

  before_action :authenticate_user!, only: [:show]
  before_action -> { check_admin_role(current_user) }, only: [:show]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end
end
