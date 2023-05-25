class LotsController < ApplicationController
  def index
    @lots = Lot.all
  end

  def show
    @lot = Lot.find(params[:id])
    total_bids_amount = @lot.bids.sum(:amount) || 0
    @current_bid = total_bids_amount.to_i + @lot.min_value.to_i
    @time_left = @lot.end_date - Time.zone.now
    @lot_ended = Time.zone.now > @lot.end_date

    winner_id = @lot.bids.last&.user_id if @lot_ended
    @winner = User.find(winner_id) if winner_id

    render :show
  end

  def search
    query = params[:query]
    @lots = Lot.joins(:products).where(
      "batch_code LIKE ? OR products.name LIKE ?", "%#{query}%", "%#{query}%"
    ).distinct
    @lots.where(status: :approved).each { |lot| lot.update_status }

    if current_user&.is_admin?
      @lots = Lot.where(status: params[:status]) unless params[:status].nil?
      return render "admin/lots/index"
    end
    render :index
  end
end
