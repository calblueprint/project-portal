# == Schema Information
#
# Table name: questions
#
#  id              :integer          not null, primary key
#  question        :string(255)
#  input_type      :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted         :string(255)
#  organization_id :integer
#

require 'spec_helper'

describe Question do
  pending "add some examples to (or delete) #{__FILE__}"
end
