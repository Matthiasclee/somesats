class AddPaymentKeyToGiftCard < ActiveRecord::Migration[7.0]
  def change
    add_column :gift_cards, :payment_key, :string, null: false
  end
end
