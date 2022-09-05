class CreateItems < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL.squish
      CREATE TYPE item_status AS ENUM ('unspecified', 'negative', 'disputed');
    SQL

    create_table :items do |t|
      t.references :trade_line, foreign_key: true, null: false
      t.references :bureau, foreign_key: true, null: false

      t.timestamps
    end

    add_column :items, :status, :item_status, null: false, default: 'unspecified', index: true
  end

  def down
    drop_table :items

    execute <<-SQL
      DROP TYPE item_status;
    SQL
  end
end
