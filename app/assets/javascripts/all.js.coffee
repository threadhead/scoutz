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
