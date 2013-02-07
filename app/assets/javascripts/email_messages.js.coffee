jQuery ->
  $("select#email_message_send_to_unit").change ->
    if $(@).val() == "2"
      $("#email-sub-unit-list").collapse("show")
    else
      $("#email-sub-unit-list").collapse("hide")
