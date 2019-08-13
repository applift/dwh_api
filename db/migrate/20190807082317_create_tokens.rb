class CreateTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :tokens do |t|
      t.string :code, null: false, unique: true
      t.string :name, null: false, unique: true
      t.timestamps
    end
    add_index :tokens, :code
  end
end
