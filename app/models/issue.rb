class Issue < ActiveRecord::Base
  belongs_to :project
  has_many :tags
  attr_accessible :description, :resolved, :title

  validates :title, :presence => true,
  					:length => { :maximum => 50 }
  validates :description, :presence => true
  validates :project_id, :presence => {:message => "ID missing. Fatal Error. Restart." }

  scope :by_title, lambda { |search_string|
    if not search_string.empty?
      where('title like ?', "%#{search_string}%")
    end
  }

  def self.search(params)
	  Issue.by_title(params)
  end

end
