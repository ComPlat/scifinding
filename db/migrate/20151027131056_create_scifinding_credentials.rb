class CreateScifindingCredentials < ActiveRecord::Migration
  def change
    create_table :scifinding_credentials do |t|
      t.string :username
      t.string :encrypted_password
      t.string :encrypted_current_token
      t.string :encrypted_refreshed_token
      t.datetime :token_expires_at
      t.datetime :token_requested_at
      t.timestamps null: false
    end unless ActiveRecord::Base.connection.table_exists? "scifinding_credentials"
  end
end
