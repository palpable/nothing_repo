class CbPost < ActiveRecord::Base
   include ActivityLogger
  has_many :activities, :foreign_key => "item_id", :dependent => :destroy,
                        :conditions => "item_type = 'CbPost'"
   attr_accessible nil
   is_indexed :fields => [ 'body' ],
             :conditions => "type = 'CbPost'",
             :include => [
                            {:association_name => 'cb_topic', :field => 'name'},
                            {:association_name => 'person', :field => 'name', :as => 'person_name'}
                         ]

  attr_accessible :body

  belongs_to :cb_topic,  :counter_cache => true
  belongs_to :person, :counter_cache => true

  validates_presence_of :body, :person
  validates_length_of :body, :maximum => 5000

  after_create :log_activity

  private

    def log_activity
      add_activities(:item => self, :person => person)
    end
end
