class RoadShowUploadChange < ActiveRecord::Migration
  def self.up
       add_column :docattachments, :state, :string
 end

  def self.down
     remove_column :docattachments, :state
  end
end
