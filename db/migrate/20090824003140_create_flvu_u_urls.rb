class CreateFlvuUUrls < ActiveRecord::Migration
  def self.up
    create_table :flvu_u_urls do |t|
      t.string :addr
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :flvu_u_urls
  end
end
