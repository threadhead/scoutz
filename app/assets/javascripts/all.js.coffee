jQuery ->
  # focus_field = $('input:text:visible:first')
  # focus_field.focus()
  # focus_field.select()

  $('.datetime-picker').datetimepicker(
    dateFormat: 'yy-mm-dd',
    stepMinute: 15,
    minuteGrid: 15,
    hourGrid: 6
    )

  $("[data-toggle='tooltip']").tooltip()

  $("select#select_default_unit").change ->
    if $(@).val()
      console.log $(@).val()
      $(@).closest('form').submit()

  $("#scoutz-navbar-collapse").on('shown.bs.collapse', ->
    console.log "scoutz-navbar-collapse:shown"

    setNavbarLowerTop()
    setPaddingTop()
    )

  $("#scoutz-navbar-collapse").on('hidden.bs.collapse', ->
    console.log "scoutz-navbar-collapse:hidden"

    setNavbarLowerTop()
    setPaddingTop()
    )


  $("#unit-navbar-collapse").on('shown.bs.collapse', ->
    console.log "unit-navbar-collapse:shown"
    setPaddingTop()
    )

  $("#unit-navbar-collapse").on('hidden.bs.collapse', ->
    console.log "unit-navbar-collapse:hidden"
    setPaddingTop()
    )


  setNavbarLowerTop = ->
    h = $("#navbar-fixed-upper").position().top - 2 + $("#navbar-fixed-upper").outerHeight()
    console.log "  navbar uppper-position: #{h}"
    $("#navbar-fixed-lower").css("top", "#{h}px")


  setPaddingTop = ->
    b = $("#navbar-fixed-lower").position().top - 2 + $("#navbar-fixed-lower").outerHeight()
    console.log "  navbar lower-position: #{b}"
    $("body").css("padding-top", "#{b}px")


#  $('.navbar-lower').affix({
#    offset: {top: 50}
#    })

  # this could be used to get dropdown on nav menus, but clicked menus will remain open
  # becuase of the odd behavior, used the bootstrap_dropdown_hover.js
  #  $('ul.nav li.dropdown').hover ->
  #    $(this).find('.dropdown-menu').stop(true, true).delay(200).fadeIn(), ->
  #      $(this).find('.dropdown-menu').stop(true, true).delay(200).fadeOut()
