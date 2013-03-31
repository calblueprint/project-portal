require "spec_helper"

describe "Yes or No" do
  it "returns yes for true" do
    expect(helper.yes_no(true)).to eq("Yes")
  end
  it "returns no for false" do
    expect(helper.yes_no(false)).to eq("No")
  end
end

describe "url with http" do
  it "adds protocol to link with missing protocol" do
    expect(helper.url_with_http("www.google.com")).to eq("http://www.google.com")
  end
  it "does not add protocol if already exists in link" do
    expect(helper.url_with_http("http://www.google.com")).to eq("http://www.google.com")
  end
end

describe "displaying image" do
  it "should display default when no image present" do
    expect(helper.img_or_default(false)).to eq(DEFAULT_IMG)
  end
  it "should display image when url present" do
    expect(helper.img_or_default("imageurl")).to eq("imageurl")
  end
end