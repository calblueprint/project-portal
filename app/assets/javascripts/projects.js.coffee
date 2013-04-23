# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$("#proj-tab a").click (e) ->
  e.preventDefault()
  $(this).tab "show"

$("#proj-tab a:first").tab "show"

checkScrollCallback = (data) ->
  full = $(data).find('#full-proj-view')
  $('#full-proj-view').append(full)
  compact = $(data).find('#compact-proj-view')
  $('#compact-proj-view').append(compact)
  square = $(data).find('#square-proj-view').html()
  $('#square-proj-view').append(square)

$(document).ready ->
  checkScroll(checkScrollCallback)
