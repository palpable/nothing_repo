class NewsFeedToUser < ActiveRecord::Migration
  def self.up
    add_column :people ,:news_id,:integer
  end

  def self.down
    remove_column :people,:news_id
  end
end
