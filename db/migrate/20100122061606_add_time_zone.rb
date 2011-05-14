class AddTimeZone < ActiveRecord::Migration
  def self.up
      add_column :people,:time_zone,:string
  end

  def self.down
      add_column :people,:time_zone,:string
  end

end
