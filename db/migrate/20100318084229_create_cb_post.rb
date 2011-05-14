class CreateCbPost < ActiveRecord::Migration
  def self.up
    create_table :cb_posts do |t|
      t.integer :blog_id
      t.integer :cb_topic_id
      t.integer :person_id
      t.string  :title
      t.text    :body
      t.integer :blog_post_comments_count, :null => false, :default => 0
      t.string  :type

      t.timestamps
    end
    add_index :cb_posts, :blog_id
    add_index :cb_posts, :cb_topic_id
    add_index :cb_posts, :type
  end

  def self.down
      drop_table :cb_posts
  end
end
