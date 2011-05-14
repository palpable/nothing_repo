class AlterCbTopic < ActiveRecord::Migration
  def self.up
    remove_column :cb_topics,:cb_forum_posts_count
    add_column :cb_topics,:cb_posts_count,:integer, :null => false, :default => 0
  end

  def self.down
    remove_column :cb_topics,:cb_posts_count
    add_column :cb_topics,:cb_forum_posts_count,:integer, :null => false, :default => 0
  end
end
