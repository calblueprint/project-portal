class Issue < ActiveRecord::Base
  belongs_to :project
  has_many :tags
  attr_accessible :description, :resolved, :title

  validates :title, :presence => true,
  					:length => { :maximum => 50 }
  validates :description, :presence => true
  validates :project_id, :presence => {:message => "ID missing. Fatal Error. Restart." }
end
