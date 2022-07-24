class CreateGiftCards < ActiveRecord::Migration[7.0]
  def change
    create_table :gift_cards, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.integer :sats, null: false
      t.integer :valid_for, default: 'gen_random_uuid()', null: false
      t.string :redemption_code, default: '', null: false
      t.boolean :paid, default: false, null: false

      t.timestamps
    end
  end
end
