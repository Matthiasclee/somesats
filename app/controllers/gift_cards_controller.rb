require "net/http"

class GiftCardsController < ApplicationController
  before_action :set_gift_card, only: %i[ show pay confirm_payment ]
  FEE=2

  # GET /gift_cards/1 or /gift_cards/1.json
  def show
    @show_redemption_code = true if params[:redemption_code] == @gift_card.redemption_code
    
    if params[:print] == "true"
      @btc_logo = File.read(Rails.root.join("public", "btc_logo_base64"))
      render partial: "card", layout: false
      return
    end
  end

  # GET /gift_cards/new
  def new
    @gift_card = GiftCard.new
  end

  # POST /gift_cards or /gift_cards.json
  def create
    @gift_card = GiftCard.new(gift_card_params)
    @gift_card.valid_for = 1.year.to_i
    @gift_card.redemption_code = SecureRandom.uuid
    @gift_card.sats = 0
    @gift_card.payment_key = ::Bitcoin::Key.generate.to_base58

    respond_to do |format|
      if @gift_card.save
        format.html { redirect_to gift_card_url(@gift_card) + "?redemption_code=#{@gift_card.redemption_code}", notice: "Gift card was successfully created." }
        format.json { render :show, status: :created, location: @gift_card }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gift_card.errors, status: :unprocessable_entity }
      end
    end
  end

  def pay
    @address = ::Bitcoin::Key.from_base58(@gift_card.payment_key).addr
    resp = Net::HTTP.get(URI("https://blockchain.info/balance?active=#{@address}"))
    @balance = JSON.parse(resp)[@address]["final_balance"].to_i
    @unpaid_balance = (@gift_card.starting_sats+(@gift_card.starting_sats/(100.0/FEE))).to_i - @balance
  end

  def confirm_payment
    @address = ::Bitcoin::Key.from_base58(@gift_card.payment_key).addr
    resp = Net::HTTP.get(URI("https://blockchain.info/balance?active=#{@address}"))
    @balance = JSON.parse(resp)[@address]["final_balance"].to_i
    @unpaid_balance = (@gift_card.starting_sats+(@gift_card.starting_sats/(100.0/FEE))).to_i - @balance
    
    if @unpaid_balance < 1
      @gift_card.paid = true
      @gift_card.sats = @gift_card.starting_sats
      @gift_card.save

      redirect_to gift_card_url(@gift_card)
    else
      redirect_to gift_cards_pay_path(@gift_card)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gift_card
      @gift_card = GiftCard.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gift_card_params
      params.require(:gift_card).permit(:starting_sats)
    end
end
