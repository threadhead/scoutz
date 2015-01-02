jQuery ->

  $(".time-only-picker").timepicker
    'showDuration': true
    'timeFormat': 'g:ia'

  $('.date-only-picker').datepicker
    format: "M dd, yyyy"
    todayBtn: "linked"
    orientation: "top auto"
    autoclose: true
    todayHighlight: true

  $("#date-time-pair").datepair()

  $('#calendar').fullCalendar
    dayClick: (date) ->
      if $("input#user_can_new_event").val() == 'true'
        newEventUrl = $("a#new-event").attr('href')
        queryDate = '?start_at=' + date.format()
        # alert "url: #{newEventUrl}#{queryDate}"
        window.location = newEventUrl + queryDate
    header:
      left: 'today prev,next title'
      center: ''
      right: 'month,agendaWeek,agendaDay'
    events:
      url: '/events.json'
      data: ->
        unit_id: $("input#current_unit_id").val()
    theme: false
    height: 600
    editable: false
    eventLimit: true


  $("select#event_kind").change ->
    # switch $(@).val()
    #   when "3" then $("#sub-unit-list").collapse("show")
    #   else $("#sub-unit-list").collapse("hide")
    subUnitRegex = /Patrol|Den|Lodge/
    if $(@).val().match subUnitRegex
      $("#sub-unit-list").collapse("show")
    else
      $("#sub-unit-list").collapse("hide")


  if $("#gmap").length > 0
    GMaps.geocode
      address: $("#gmap").data("address")
      callback: (results, status) ->
        if (status == 'OK')
          map = new GMaps
            div: "#gmap"
            lng: 0
            lat: 0
            zoomControl : true
            zoomControlOptions:
                style: google.maps.ZoomControlStyle.SMALL
                position: google.maps.ControlPosition.TOP_LEFT
            panControl: false

          latlng = results[0].geometry.location
          map.setCenter(latlng.lat(), latlng.lng())
          map.addMarker
            lat: latlng.lat()
            lng: latlng.lng()


  $("#event-signup-add").on("click", "button#add-event-signup-button", ->
    scoutId = $("select#add-event-signup-select").val()
    eventId = $("select#add-event-signup-select").data("event-id")
    if scoutId
      # console.log "s: #{scoutId}, e: #{eventId}"
      $.getScript("/event_signups/new.js?scout_id=#{scoutId}&event_id=#{eventId}", (data, textStatus, jqxhr) ->
        $("div#event-signup-modal-form").modal()
        )
    )

  $("table#event-signup-roster").on("click", "a.edit-event-signup-modal", ->
    eventSignupId = $(@).data("event-signup-id")
    $.getScript("/event_signups/#{eventSignupId}/edit.js", (data, textStatus, jqxhr) ->
      $("div#event-signup-modal-form").modal()
      )
    )
