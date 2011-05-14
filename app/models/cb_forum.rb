class CbForum < ActiveRecord::Base
  attr_accessible :name, :description

  has_many :cb_topic,  :dependent => :destroy
  has_many :cb_post, :through => :cb_topic


  validates_length_of :name, :maximum => 255, :allow_nil => true
  validates_length_of :description, :maximum => 1000, :allow_nil => true
end
