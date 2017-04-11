class AddBioToChefs < ActiveRecord::Migration[5.0]
  def change
    add_column :chefs, :biography, :text
  end
end
