# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ () ->
  CodeMirror.fromTextArea($('#chart_config')[0], {
    mode: "text/x-yaml"
    tabSize: 2
    lineNumbers: true
    })