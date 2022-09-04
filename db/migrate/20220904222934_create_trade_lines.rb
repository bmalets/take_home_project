class CreateTradeLines < ActiveRecord::Migration[7.0]
  def change
    create_table :trade_lines do |t|
      t.string :name, null: false
      t.jsonb :raw, null: false

      t.timestamps
    end
  end
end
