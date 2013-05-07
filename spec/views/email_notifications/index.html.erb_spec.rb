require 'spec_helper'

describe "email_notifications/index" do
  before(:each) do
    assign(:email_notifications, [
      stub_model(EmailNotification,
        :edit => "Edit",
        :update => "Update"
      ),
      stub_model(EmailNotification,
        :edit => "Edit",
        :update => "Update"
      )
    ])
  end

  it "renders a list of email_notifications" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Edit".to_s, :count => 2
    assert_select "tr>td", :text => "Update".to_s, :count => 2
  end
end
