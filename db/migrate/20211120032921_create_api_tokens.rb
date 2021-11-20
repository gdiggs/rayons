class CreateApiTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :api_tokens do |t|
      t.string :name
      t.string :token
      t.integer :user_id

      t.timestamps
    end
    add_index :api_tokens, :token
  end
end
