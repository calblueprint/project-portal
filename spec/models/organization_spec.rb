# == Schema Information
#
# Table name: organizations
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  website     :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sname       :string(255)
#

require 'spec_helper'

describe Organization do
  pending "add some examples to (or delete) #{__FILE__}"
end
