class AddCbPostCountToPeople < ActiveRecord::Migration
  def self.up
     add_column :people,:cb_posts_count,:integer, :null => false, :default => 0
  end

  def self.down
     remove_column :people,:cb_posts_count
  end
end
