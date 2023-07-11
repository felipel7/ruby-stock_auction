class BidsController < ApplicationController
  before_action :authenticate_user!, only: %i[index create]

  def index
    @user_bids = current_user.bids
    @lots = @user_bids.map(&:lot).uniq
    @winning_lots = @lots.select { |lot| lot.bids.last.user_id == current_user.id }

    return unless current_user&.admin?

    @all_bids = Bid.all
    render 'bids/admin/index'
  end

  def new
    @bid = Bid.new
  end

  def create
    @lot = Lot.find(params[:id])

    if current_user&.admin?
      flash[:warning] = t('bids.warning.save')
      redirect_to root_path
    else
      @bid = Bid.new(user: current_user, lot: @lot, amount: params[:amount].to_i)
      if @bid.save
        flash[:notice] = t('bids.success.save')
      else
        flash[:alert] = "Não foi possível dar o lance. #{@bid.errors&.full_messages[0]}"
      end
      redirect_to @lot
    end
  end
end
