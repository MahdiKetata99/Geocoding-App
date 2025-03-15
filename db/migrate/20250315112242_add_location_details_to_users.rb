class AddLocationDetailsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :country, :string
    add_column :users, :postal_code, :string
    add_column :users, :district, :string
    add_column :users, :formatted_address, :string
  end
end
