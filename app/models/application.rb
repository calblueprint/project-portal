class Application < ActiveRecord::Base
  attr_accessible :organization_id, :project_id, :questions
  serialize :questions, Hash

  belongs_to :project
  belongs_to :organization
end
