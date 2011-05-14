class AddInviteToPepole < ActiveRecord::Migration
  def self.up
    add_column :people,:inviter_id,:integer
    add_column :people,:invitation_code,:string
  end

  def self.down
     remove_column :people,:inviter_id,:integer
    remove_column :people,:invitation_code,:string
  end
end
