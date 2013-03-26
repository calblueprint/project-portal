module ApplicationHelper
  def url_with_http(url)
    /^http/.match(url) ? url : "http://#{url}"
  end
  
  def yes_no(bool)
    bool ? "Yes" : "No"
  end
  
  def img_or_default(img)
    img ? img : DEFAULT_IMG
  end
end
