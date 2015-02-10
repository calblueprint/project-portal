# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  project_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Favorite do
  pending "add some examples to (or delete) #{__FILE__}"
end
