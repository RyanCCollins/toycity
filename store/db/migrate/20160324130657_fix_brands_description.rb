class FixBrandsDescription < ActiveRecord::Migration
  def change
    rename_column :brands, :desctiption, :description
  end
end
