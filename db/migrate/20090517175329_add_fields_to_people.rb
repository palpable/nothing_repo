class AddFieldsToPeople < ActiveRecord::Migration
    def self.up
      add_column(:people, :branch, :string)
      add_column(:people, :years, :integer)
      add_column(:people, :phone, :string)
      add_column(:people, :fax, :string)
    end

    def self.down
      remove_column(:people, :branch)
      remove_column(:people, :years)
      remove_column(:people, :phone)
      remove_column(:people, :fax)
    end
  end
