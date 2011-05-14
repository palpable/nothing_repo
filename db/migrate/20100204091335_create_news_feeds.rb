class CreateNewsFeeds < ActiveRecord::Migration
  def self.up
    create_table :news_feeds do |t|
      t.column :name,:string
      t.column :addr,:string
      t.timestamps
    end
  end

  def self.down
    drop_table :news_feeds
  end
end
