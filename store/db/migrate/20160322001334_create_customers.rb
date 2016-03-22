class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|

      t.string :name

      t.timestamps null: false
    end
    create_table :transactions do |t|
      t.decimal :amount
      t.references :product, index: true, foreign_key: true
      t.references :customer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
