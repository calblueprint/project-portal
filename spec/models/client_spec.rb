# == Schema Information
#
# Table name: clients
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_name       :string(255)
#  company_site       :string(255)
#  company_address    :string(255)
#  nonprofit          :boolean
#  five_01c3          :boolean
#  mission_statement  :string(255)
#  contact_email      :string(255)
#  contact_number     :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

require 'spec_helper'

describe Client do
  pending "add some examples to (or delete) #{__FILE__}"
end
