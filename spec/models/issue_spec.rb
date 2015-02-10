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

require 'spec_helper'

describe Issue do
  before(:each) do
		@attr = {:title => "TITLE", :description => "description", :resolved => false }
	end

	it "should create a new instance given valid attributes" do
		Issue.create!(@attr)
	end

	it "should require a name" do
		noTitle = Issue.new(@attr.merge(:title => ""))
		noTitle.should_not be_valid
	end

	it "should require a descirption" do
		noDesc = Issue.new(@attr.merge(:description => ""))
		noDesc.should_not be_valid
	end

	it "should reject titles that are to long" do
		title = 'a'*51
		longTitle = Issue.new(@attr.merge(:title => title))
		longTitle.should_not be_valid
	end
end
