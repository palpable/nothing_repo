class CreateInvitationCounts < ActiveRecord::Migration
  def self.up
    create_table :invitation_counts do |t|
      t.column :user_id,:integer
      t.timestamps
    end
  end

  def self.down
    drop_table :invitation_counts
  end
end
