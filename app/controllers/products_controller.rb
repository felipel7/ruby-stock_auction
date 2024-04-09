class ProductsController < ApplicationController
  include Pagination
  POSTS_PER_PAGE = 6

  def index
    @pagination, @products = paginate(collection: Product.all, params: page_params)
  end

  def show
    @product = Product.find(params[:id])
  end

  def page_params
    params.permit(:page).merge(per_page: POSTS_PER_PAGE)
  end
end
