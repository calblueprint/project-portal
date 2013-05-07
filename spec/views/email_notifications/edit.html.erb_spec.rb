require 'spec_helper'

describe "email_notifications/edit" do
  before(:each) do
    @email_notification = assign(:email_notification, stub_model(EmailNotification,
      :edit => "MyString",
      :update => "MyString"
    ))
  end

  it "renders the edit email_notification form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", email_notification_path(@email_notification), "post" do
      assert_select "input#email_notification_edit[name=?]", "email_notification[edit]"
      assert_select "input#email_notification_update[name=?]", "email_notification[update]"
    end
  end
end
