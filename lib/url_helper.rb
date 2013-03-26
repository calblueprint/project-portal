def url_with_http(url)
  /^http/.match(url) ? url : "http://#{url}"
end
