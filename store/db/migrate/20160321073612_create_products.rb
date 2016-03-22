class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.decimal :price
      t.string :stock
      t.has_one :brand

      t.timestamps null: false
      t.has_one :brand
    end
  end
end
