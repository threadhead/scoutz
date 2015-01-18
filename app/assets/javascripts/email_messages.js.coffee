jQuery ->
  $("#email-leaders-list").collapse
    toggle: false

  $("#email-send-to-users-list").collapse
    toggle: false

  $("#email-sub-unit-list").collapse
    toggle: false

  $("select#email_message_send_to_option").change ->
    handleSendToLists(@)

  $("select#sms_message_send_to_option").change ->
    handleSendToLists(@)


  handleSendToLists = (sel) ->
    switch $(sel).val()
      when "2"
        $("#email-leaders-list").collapse("show")
        $("#email-send-to-users-list").collapse("hide")
        $("#email-sub-unit-list").collapse("hide")

      when "3"
        $("#email-send-to-users-list").collapse("hide")
        $("#email-leaders-list").collapse("hide")
        $("#email-sub-unit-list").collapse("show")


      when "4"
        $("#email-sub-unit-list").collapse("hide")
        $("#email-leaders-list").collapse("hide")
        $("#email-send-to-users-list").collapse("show")

      else
        $("#email-leaders-list").collapse("hide")
        $("#email-sub-unit-list").collapse("hide")
        $("#email-send-to-users-list").collapse("hide")


  $("select#email_message_user_ids").select2
    placeholder: 'Select recipients'

  $("select#sms_message_user_ids").select2
    placeholder: 'Select recipients'

  # $("label.checkbox.sub-unit").tooltip({
  #   placement: "top"
  #   })

  $('button.add-attachment').click ->
    if $("div.email-attachment-fields").size() < 5
      new_attachment = $(".hidden#new-attachment-fields").html()
      new_id = new Date().getTime()
      regexp = new RegExp("new_email_attachment", "g")
      $("div#email-attachments").append(new_attachment.replace(regexp, new_id))
      disableAddAttachmentButton()
      $("div#email-attachments .email-attachment-fields").last().find(".well").effect('highlight', {}, 1000)

  $("div#email-attachments").on("click", "button.remove-attachment", ->
    $(@).parents("div.email-attachment-fields").hide("fade", {}, "slow", ->
      $(@).remove()
      disableAddAttachmentButton()
      )
    )

  disableAddAttachmentButton = ->
    if $("div.email-attachment-fields").size() >= 5
      $("button.add-attachment").attr("disabled", "disabled")
    else
      $("button.add-attachment").removeAttr("disabled")
