class AllTags < ActiveRecord::Base
  attr_accessible :tag
  validates_uniqueness_of :tag
  validates :tag, :presence => true,
  					:length => { :maximum => 10 }
end
