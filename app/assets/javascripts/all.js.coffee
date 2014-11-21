jQuery ->
  $(".datetime-picker").datetimepicker(
    dateFormat: 'yy-mm-dd'
    stepMinute: 15
    minuteGrid: 15
    hourGrid: 6
    )

  $(".date-picker").each ->
    # updateField = $(@).data('altfield')
    # console.log updateField
    $(@).datepicker(
      # showButtonPanel: true
      dateFormat: 'M d, yy'
      altField: String($(@).data('altfield'))
      altFormat: "yy-mm-dd"
      # onSelect: ->
        # console.log 'onSelect'
      #   console.log $("#health_form_part_a_date").val()
    )

  $("button.date-clear").click ->
    prevInput = $(@).parent().prev()
    $(prevInput).val(null)
    altField = $(prevInput.data('altfield'))
    $(altField).val(null)

  $("[data-toggle='tooltip']").tooltip()


  $("input.search-typeahead").autocomplete({
      minLength: 0,
      autoFocus: true,
      source: (request, response) ->
        searchUrl = $("input#search_action").val()
        # console.log searchUrl + request.term
        $.getScript(searchUrl + request.term )
    })

  # $("input.search-typeahead").delay(100).focus()

  $("select#select_default_unit").change ->
    if $(@).val()
      #console.log $(@).val()
      $(@).closest('form').submit()

  $("#scoutz-navbar-collapse").on('shown.bs.collapse', ->
    #console.log "scoutz-navbar-collapse:shown"
    setNavbarLowerTop()
    setPaddingTop()
    )

  $("#scoutz-navbar-collapse").on('hidden.bs.collapse', ->
    #console.log "scoutz-navbar-collapse:hidden"
    setNavbarLowerTop()
    setPaddingTop()
    )


  $("#unit-navbar-collapse").on('shown.bs.collapse', ->
    #console.log "unit-navbar-collapse:shown"
    setPaddingTop()
    )

  $("#unit-navbar-collapse").on('hidden.bs.collapse', ->
    #console.log "unit-navbar-collapse:hidden"
    setPaddingTop()
    )


  setNavbarLowerTop = ->
    h = $("#navbar-fixed-upper").position().top - 2 + $("#navbar-fixed-upper").outerHeight()
    #console.log "  navbar uppper-position: #{h}"
    $("#navbar-fixed-lower").css("top", "#{h}px")


  setPaddingTop = ->
    b = $("#navbar-fixed-lower").position().top - 2 + $("#navbar-fixed-lower").outerHeight()
    #console.log "  navbar lower-position: #{b}"
    $("body").css("padding-top", "#{b}px")
