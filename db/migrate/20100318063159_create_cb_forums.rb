class CreateCbForums < ActiveRecord::Migration
   class CbForum < ActiveRecord::Base
  end
  def self.up
    create_table :cb_forums do |t|
      t.string :name
      t.text :description
      t.integer :topics_count, :null => false, :default => 0
      t.timestamps
    end
   CbForum.create!(:name => "Discussion forum",
                  :description => "The main forum")
  end

  def self.down
    drop_table :cb_forums
  end
end
