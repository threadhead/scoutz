jQuery ->
  $("button.print-button").click ->
    window.print()

  if $("#gmap").length > 0
    GMaps.geocode
      address: $("#gmap").data("address")
      callback: (results, status) ->
        if (status == 'OK')
          latlng = results[0].geometry.location

          url = GMaps.staticMapURL
            size: [400, 230]
            lng: latlng.lng()
            lat: latlng.lat()
          $('<img/>').attr('src', url).appendTo('#gmap');

          # map.setCenter(latlng.lat(), latlng.lng())
          # map.addMarker
          #   lat: latlng.lat()
          #   lng: latlng.lng()


  $('#calendar').fullCalendar
    header:
      left: 'today prev,next title'
      center: ''
      right: ''
    events:
      url: '/events.json'
      data: ->
        unit_id: $("input#current_unit_id").val()
    theme: false
    height: 800
    editable: false
    eventLimit: false
