class AddAddressFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :street, :string
    add_column :users, :city, :string
    add_column :users, :zip, :string
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :federal_state, :string
  end
end
