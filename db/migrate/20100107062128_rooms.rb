class Rooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
       t.column :title,:string
       t.column :description,:text
       t.column :is_public,:boolean,:default => false
       t.column :person_id,:integer
       t.timestamps
     end
  end

  def self.down
  end
end
