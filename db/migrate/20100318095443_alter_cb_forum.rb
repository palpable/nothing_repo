class AlterCbForum < ActiveRecord::Migration
  def self.up
    remove_column :cb_forums,:topics_count
    add_column :cb_forums,:cb_topics_count,:integer, :null => false, :default => 0
   
  end

  def self.down
     remove_column :cb_forums,:cb_topics_count
    add_column :cb_forums,:topics_count,:integer, :null => false, :default => 0

  end
end
