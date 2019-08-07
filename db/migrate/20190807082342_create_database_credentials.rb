class CreateDatabaseCredentials < ActiveRecord::Migration[5.2]
  def change
    create_table :database_credentials do |t|
      t.string :user, null: false
      t.string :password, null: false
      t.string :database, null: false
      t.string :host, null: false
      t.string :port, null: false
      t.string :password, null: false
      t.string :salt, null: false
      t.timestamps
    end
  end
end
