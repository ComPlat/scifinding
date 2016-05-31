class CreateScifindingTags < ActiveRecord::Migration
  def change
    create_table :scifinding_tags do |t|
      t.integer :molecule_id
      t.integer :count

      t.timestamps null: false
    end unless ActiveRecord::Base.connection.table_exists? "scifinding_tags"
  end
end
