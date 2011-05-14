class CbTopic < ActiveRecord::Base
  include ActivityLogger

  MAX_NAME = 100
  NUM_RECENT = 6

  attr_accessible :name

  belongs_to :cb_forum,:counter_cache => true
  belongs_to :person
  has_many :cb_post, :order => :created_at, :dependent => :destroy
                   
  has_many :activities, :foreign_key => "item_id", :dependent => :destroy,
                        :conditions => "item_type = 'Topic'"
  validates_presence_of :name,:person
  validates_length_of :name, :maximum => MAX_NAME

  after_create :log_activity

  def self.find_recent
    find(:all, :order => "created_at DESC", :limit => NUM_RECENT)
  end

  private

    def log_activity
      add_activities(:item => self, :person => person)
    end


end
