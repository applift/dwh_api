class CreateEndpoints < ActiveRecord::Migration[5.2]
  def change
    create_table :endpoints do |t|
      t.text :query, null: false
      t.references :token, null: false
      t.references :database_credential, null: false
      t.boolean :is_active, null: false, default: true
      t.timestamps
    end
  end
end
