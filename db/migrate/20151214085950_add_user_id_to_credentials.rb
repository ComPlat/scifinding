class AddUserIdToCredentials < ActiveRecord::Migration
  def change
    add_column :scifinding_credentials, :user_id, :integer unless ActiveRecord::Base.connection.column_exists?(:scifinding_credentials, :user_id)
  end
end
