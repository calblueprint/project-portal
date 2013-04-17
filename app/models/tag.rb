class Tag < ActiveRecord::Base
  attr_accessible :issue_id, :label
  belongs_to :issue
end
