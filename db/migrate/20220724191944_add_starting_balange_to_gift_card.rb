class AddStartingBalangeToGiftCard < ActiveRecord::Migration[7.0]
  def change
    add_column :gift_cards, :starting_sats, :integer, null: false
  end
end
