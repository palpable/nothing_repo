class CreateCbTopics < ActiveRecord::Migration
  def self.up
    create_table :cb_topics do |t|
       t.integer :cb_forum_id
      t.integer :person_id
      t.string  :name
      t.integer :cb_forum_posts_count, :null => false, :default => 0
      t.timestamps
    end
    add_index :cb_topics, :cb_forum_id
  end

  def self.down
    drop_table :cb_topics
  end
end
