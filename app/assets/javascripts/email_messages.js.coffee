jQuery ->
  $("select#email_message_send_to_option").change ->
    handleSendToLists(@)

  $("select#sms_message_send_to_option").change ->
    handleSendToLists(@)


  handleSendToLists = (sel) ->
    switch $(sel).val()
      when "2"
        emailShowElemHideOthers("#email-leaders-list")

      when "3"
        emailShowElemHideOthers("#email-sub-unit-list")

      when "4"
        emailShowElemHideOthers("#email-send-to-users-list")
        $("div#s2id_email_message_user_ids").find("#s2id_autogen1").focus()

      when "5"
        emailShowElemHideOthers("#email-scoutmasters-list")

      when "8"
        emailShowElemHideOthers("#email-group-list")

      else
        emailShowElemHideOthers('')

  emailKindDivs = ->
    ['#email-leaders-list', '#email-send-to-users-list', '#email-sub-unit-list', '#email-scoutmasters-list', '#email-group-list']

  $.each(emailKindDivs(), (idx, elem) ->
    $(elem).collapse(toggle: false)
    )


  emailShowElemHideOthers = (elem) ->
    $.each(emailKindDivs(), (idx, div) ->
      if div != elem
        # console.log "hiding: #{div}"
        $(div).collapse("hide")
      )
    # console.log "showing: #{elem}"
    $(elem).collapse("show")


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


  $("select#email_message_email_group_id").change ->
    $(".email-groups").addClass("hidden")
    $("#email-group-#{$(@).val()}").removeClass("hidden")
