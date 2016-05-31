class AddDetailsToCredential < ActiveRecord::Migration
  def change
    add_column :scifinding_credentials, :encrypted_password_iv, :string  unless ActiveRecord::Base.connection.column_exists?(:scifinding_credentials, :encrypted_password_iv)
    add_column :scifinding_credentials, :encrypted_current_token_iv, :string unless ActiveRecord::Base.connection.column_exists?(:scifinding_credentials, :encrypted_current_token_iv)
    add_column :scifinding_credentials, :encrypted_refreshed_token_iv, :string unless ActiveRecord::Base.connection.column_exists?(:scifinding_credentials, :encrypted_refreshed_token_iv)
  end
end
