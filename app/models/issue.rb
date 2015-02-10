# == Schema Information
#
# Table name: issues
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  resolved     :integer          default(0)
#  project_id   :integer          not null
#  authors      :string(255)
#  github       :string(255)
#  submitter_id :integer
#

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
