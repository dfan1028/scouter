class CreateProduct < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :ext_id, null: false
      t.string :category
      t.string :dimensions
      t.string :rank
      t.string :platform

      t.timestamps
    end

    add_index :products, :ext_id
  end
end
