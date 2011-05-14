class AddDefaultNewsfeed < ActiveRecord::Migration
  def self.up
    add_column :news_feeds, :set_default,:boolean,:default => false
  end

  def self.down
    remove_column :news_feeds,:set_default
  end
end
