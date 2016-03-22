class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
