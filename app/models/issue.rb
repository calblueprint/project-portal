class Issue < ActiveRecord::Base
  attr_accessible :description, :resolved, :title

  validates :title, :presence => true,
  					:length => { :maximum => 50 }
  validates :description, :presence => true
end
