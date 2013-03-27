module ApplicationHelper
  # We want to return empty string rather than nil for viewing purpose
  def url_with_http(url)
    if url
      /^http/.match(url) ? url : "http://#{url}"
    else 
      return ""
    end
  end
  
  def yes_no(bool)
    bool ? "Yes" : "No"
  end
  
  def img_or_default(img)
    img ? img : DEFAULT_IMG
  end
end
