class OrdersController < ApplicationController
 before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
    @campaign = @order.campaign
    @amount = @campaign.price*100
  end

  def create

    @order = Order.new(order_params).merge(email: stripe_params["stripeEmail"],
                                                               card_token: stripe_params["stripeToken"])
    raise "Please, check order errors" unless @order.valid?
    @order.process_payment
    @order.save
    redirect_to @order, notice: 'order was successfully created.'

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )
    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )
    rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to :back

  end

  def edit
  end

  def show
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_order
      @order = current_campaign.orders.find(params[:id])
  end

  def current_campaign
    @current_campaign = Campaign.find(params[:campaign_id])
  end

  def order_params
    params.require(:order).permit(:campaign_id, :customer_id, :email, :full_name, :address, :city, :zip_code, :qty, :card_token)
  end

  def stripe_params
      params.permit :stripeEmail, :stripeToken
  end

end
