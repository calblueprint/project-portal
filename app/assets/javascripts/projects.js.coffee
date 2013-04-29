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

# for adding and deleting comments
jQuery ->
  # Create a comment
  $(".comment-form")
    .on "ajax:beforeSend", (evt, xhr, settings) ->
      $(this).find('textarea')
        .addClass('uneditable-input')
        .attr('disabled', 'disabled');
    .on "ajax:success", (evt, data, status, xhr) ->
      $(".comment-form").find('textarea')
        .val('');
      $(xhr.responseText).hide().insertAfter(this).show('slow')
    .on "ajax:complete", ->
      $(this).find('textarea')
        .removeClass('uneditable-input')
        .removeAttr('disabled', 'disabled');
  #Delete a comment
  $(document)
    .on "ajax:beforeSend", ".comment1", ->
      $(this).fadeTo('fast', 0.5)
    .on "ajax:success", ".comment1", ->
      $(this).hide('fast')
    .on "ajax:error", ".comment1", ->
      $(this).fadeTo('fast', 1)
