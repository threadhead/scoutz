jQuery ->
  $("#email-send-to-users-list").collapse({
    toggle: false
    })
  $("#email-sub-unit-list").collapse({
    toggle: false
    })

  $("select#email_message_send_to_option").change ->
    switch $(@).val()
      when "2"
        $("#email-send-to-users-list").collapse("hide")
        $("#email-sub-unit-list").collapse("show")
        true

      when "3"
        $("#email-sub-unit-list").collapse("hide")
        $("#email-send-to-users-list").collapse("show")

      else
        $("#email-sub-unit-list").collapse("hide")
        $("#email-send-to-users-list").collapse("hide")


  $("select#email_message_user_ids").select2({
    placeholder: 'Select recipients'
    })
