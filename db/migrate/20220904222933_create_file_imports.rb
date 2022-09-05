class CreateFileImports < ActiveRecord::Migration[7.0]
  def change
    create_table :file_imports do |t|
      t.timestamps
    end
  end
end
