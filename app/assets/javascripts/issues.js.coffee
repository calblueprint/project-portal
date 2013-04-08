# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#For in place editing:
jQuery ->
  $('.best_in_place').best_in_place()

# For the lightbox:
close_box = ->
  $(".backdrop, .box").animate
    opacity: "0"
  , 300, "linear", ->
    $(".backdrop, .box").css "display", "none"

$(document).ready ->
  $(".lightbox").click ->
    $(".backdrop, .box").animate
      opacity: ".50"
    , 300, "linear"
    $(".box").animate
      opacity: "1.00"
    , 300, "linear"
    $(".backdrop, .box").css "display", "block"

  $(".close").click ->
    close_box()

  $(".backdrop").click ->
    close_box()

$(document).ready ->
  $("#openSearch").click ->
    $("#search-issues-box").slideToggle "slow"
