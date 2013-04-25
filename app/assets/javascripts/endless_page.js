var currentPage = 1;

function checkScroll(callback) {
  if (nearBottomOfPage() && allowScroll()) {
    currentPage++;
    $.ajax({
      url: window.location.pathname + "?page=" + currentPage,
      dataType: "html",
      success: function(data){
        if(data){
          callback(data);
          checkScrollTimeout(callback, 1000);
        }
      }
    })
  } else {
    checkScrollTimeout(callback, 250);
  }
}

function nearBottomOfPage() {
  return scrollDistanceFromBottom() < 150;
}

function scrollDistanceFromBottom(argument) {
  return pageHeight() - (window.pageYOffset + self.innerHeight);
}

function pageHeight() {
  return Math.max(document.body.scrollHeight, document.body.offsetHeight);
}

function checkScrollTimeout(callback, time) {
  setTimeout(function() {
    checkScroll(callback)
  }, time)
}


function allowScroll() {
  return !($('#allow-endless-scroll') == null || $('#allow-endless-scroll').length == 0)
}