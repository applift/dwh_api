class AddNameToEndpoint < ActiveRecord::Migration[5.2]
  def change
    add_column :endpoints, :name, :string, null: false, unique: true
  end
end
