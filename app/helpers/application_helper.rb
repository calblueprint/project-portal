module ApplicationHelper
  def url_with_http(url)
    /^http/.match(url) ? url : "http://#{url}"
  end
  
  def yes_no(bool)
    bool ? "Yes" : "No"
  end
end
