require 'spec_helper'

describe "email_notifications/show" do
  before(:each) do
    @email_notification = assign(:email_notification, stub_model(EmailNotification,
      :edit => "Edit",
      :update => "Update"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Edit/)
    rendered.should match(/Update/)
  end
end
