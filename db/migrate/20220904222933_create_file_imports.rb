class CreateFileImports < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL.squish
      CREATE TYPE import_status AS ENUM ('pending', 'failed', 'success');
    SQL

    create_table :file_imports do |t|
      t.timestamps
    end

    add_column :file_imports, :status, :import_status, null: false, default: 'pending', index: true
  end

  def down
    drop_table :file_imports

    execute <<~SQL.squish
      DROP TYPE import_status;
    SQL
  end
end
