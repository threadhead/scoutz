# moment.parseZone($("input#last_unit_meeting_start_at").val()).add(moment.duration({weeks: 1})).format();
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



  $("#sub-unit-list").collapse(toggle: false)
  $("#unit-meeting-kind").collapse(toggle: false)

  $("select#event_kind").change ->
    unitMeeting = /troop meeting|pack meeting|crew meeting/
    unitEvent = '/troop event|pack event|crew event/'
    subUnitEvent = /patrol event|den event|lodge event/
    outingEvent = /camping\/outing/
    leaderEvent = /leader event/

    selected = $(@).val().toLowerCase()

    if selected.match unitMeeting
      showElemHideOthers("#unit-meeting-kind")
      setUnitMeetingDefaults()

    else if selected.match subUnitEvent
      showElemHideOthers("#sub-unit-list")

    else if selected.match outingEvent
    else if selected.match leaderEvent
    else if selected.match unitEvent
    else

    if !selected.match subUnitEvent
      $("#sub-unit-list").collapse("hide")

  showElemHideOthers = (elem) ->
    allDivs = ['#unit-meeting-kind', '#sub-unit-list']
    $.each(allDivs, (idx, div) ->
      if div != elem
        console.log "hiding: #{div}"
        $(div).collapse("hide")
      )

    $(elem).collapse("show")


  $("button#copy-last-unit-meeting").click ->
    unitId = $("input#unit_id").val()
    $.getJSON( "/units/#{unitId}/events/last_unit_meeting.json", (data) ->
      # console.log data
      $("input#event_name").val(data['name'])

      $("input#event_location_name").val(data['location_name'])
      $("input#event_location_address1").val(data['location_address1'])
      $("input#event_location_address2").val(data['location_address2'])
      $("input#event_location_city").val(data['location_city'])
      $("input#event_location_state").val(data['location_state'])
      $("input#event_location_zip_code").val(data['location_zip_code'])
      $("input#event_location_map_url").val(data['location_map_url'])

      $("select#event_attire option[value='#{data['attire']}']").prop("selected", true)
      $("select#event_type_of_health_forms option[value='#{data['type_of_health_forms']}']").prop("selected", true)

      $("input#event_consent_required").prop('checked', data['consent_required'])

      $("select#event_form_coordinator_ids").select2("val", data['form_coordinator_ids'])

      $("input#event_signup_required").prop('checked', data['signup_required'])
      $("input#event_signup_deadline_date").val(getNextWeeksDate(data['signup_deadline']))
      $("input#event_signup_deadline_time").val(getNextWeeksTime(data['signup_deadline']))

      # $("textarea#ckeditor").val(data['message'])
      CKEDITOR.instances.ckeditor.setData(data['message'])
      $("input#event_start_at_date").val(getNextWeeksDate(data['start_at']))
      $("input#event_start_at_time").val(getNextWeeksTime(data['start_at']))
      $("input#event_end_at_date").val(getNextWeeksDate(data['end_at']))
      $("input#event_end_at_time").val(getNextWeeksTime(data['end_at']))
    )


  setUnitMeetingDefaults = ->
    # console.log 'setUnitMeetingDefaults'
    $("select#event_type_of_health_forms option[value='not_required']").prop("selected", true)
    $("input#event_consent_required").prop('checked', false)
    $("input#event_signup_required").prop('checked', false)



  getNextWeeksDate = (datetime) ->
    moment.parseZone(datetime).add(moment.duration({weeks: 1})).format("MMM D, YYYY")
  getNextWeeksTime = (datetime) ->
    moment.parseZone(datetime).add(moment.duration({weeks: 1})).format("h:mma")



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

  $("tbody#event-signup-roster").on("click", "a.edit-event-signup-modal", ->
    eventSignupId = $(@).data("event-signup-id")
    $.getScript("/event_signups/#{eventSignupId}/edit.js", (data, textStatus, jqxhr) ->
      $("div#event-signup-modal-form").modal()
      )
    )

  $("select#event_form_coordinator_ids").select2
    placeholder: 'Select recipients'
