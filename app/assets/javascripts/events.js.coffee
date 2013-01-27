# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#calendar').fullCalendar({
    dayClick: ->
      alert 'clicked a day!',
    header: {
      left: 'title',
      center: '',
      right: 'today prev,next month,basicWeek,agendaWeek'
      },
    events: '/events.json'

    })
