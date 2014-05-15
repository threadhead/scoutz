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
    events: '/events.json',
    theme: false,
    height: 600

    })

  $("select#event_kind").change ->
    # switch $(@).val()
    #   when "3" then $("#sub-unit-list").collapse("show")
    #   else $("#sub-unit-list").collapse("hide")


    subUnitRegex = /Den|Lodge/
    if $(@).val().match subUnitRegex
      $("#sub-unit-list").collapse("show")
    else
      $("#sub-unit-list").collapse("hide")

  if $("#gmap").length > 0
    GMaps.geocode({
      address: $("#gmap").data("address"),
      callback: (results, status) ->
        if (status == 'OK')
          map = new GMaps({
            div: "#gmap",
            lng: 0,
            lat: 0,
            zoomControl : true,
            zoomControlOptions: {
                style: google.maps.ZoomControlStyle.SMALL,
                position: google.maps.ControlPosition.TOP_LEFT
              },
            panControl: false,
          })

          latlng = results[0].geometry.location
          map.setCenter(latlng.lat(), latlng.lng())
          map.addMarker({
            lat: latlng.lat(),
            lng: latlng.lng()
          })
    })
