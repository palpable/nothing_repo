class CreateYoutubeULinks < ActiveRecord::Migration
  def self.up
    create_table :youtube_u_links do |t|
      t.string :title
      t.text :addr
      t.string :uniqueid
      t.string :total_time

      t.timestamps
    end
  end

  def self.down
    drop_table :youtube_u_links
  end
end
