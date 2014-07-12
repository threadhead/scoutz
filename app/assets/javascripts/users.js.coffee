jQuery ->
  $("select#scout_adult_ids").select2({
    placeholder: 'Select parents'
    })

  $("select#adult_scout_ids").select2({
    placeholder: 'Select scouts'
    })


  # $('div.remove-phone').on('click', 'button.remove-phone-button', ->
  #     removeUserPhone(@)
  #   )

  # removeUserPhone = (link) ->
  #   console.log 'remove user phone'
  #   console.log $(link).closest("input[type=hidden]")
  #   $(link).prev("input[type=hidden]").val("1")
  #   # $(link).closest(".form-group").hide()


  $('button.add-phone-button').click ->
    console.log 'add phone button'
    new_phone = $(".hidden#new-phone-fields").html()
    new_id = new Date().getTime()
    regexp = new RegExp("new_phone", "g")
    $("div#add-a-phone").before(new_phone.replace(regexp, new_id))
    # $("div#add-a-phone").closest('input[type=text]').focus()

