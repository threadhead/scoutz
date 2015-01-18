jQuery ->
  $("select#scout_adult_ids").select2
    placeholder: 'Select parents...'

  $("select#adult_scout_ids").select2
    placeholder: 'Select scouts...'

  $("select#adult_merit_badge_ids").select2
    placeholder: 'Select merit badges...'

  # $('div.remove-phone').on('click', 'button.remove-phone-button', ->
  #     removeUserPhone(@)
  #   )

  # removeUserPhone = (link) ->
  #   console.log 'remove user phone'
  #   console.log $(link).closest("input[type=hidden]")
  #   $(link).prev("input[type=hidden]").val("1")
  #   # $(link).closest(".form-group").hide()


  $('button.add-phone-button').click ->
    # console.log 'add phone button'
    new_phone = $(".hidden#new-phone-fields").html()
    new_id = new Date().getTime()
    regexp = new RegExp("new_phone", "g")
    $("div#user-phones").append(new_phone.replace(regexp, new_id))
    console.log $("div#user-phones div.user-phone-fields").last().find("input.phone-number")
    $("div#user-phones div.user-phone-fields").last().find("input.phone-number").focus()
    # $("div#add-a-phone").closest('input[type=text]').focus()

  $("div#user-phones").on("click", "button.phone-number-remove", ->
    $(@).parents("div.user-phone-fields").find("input.phone-destroy").val("1")
    $(@).parents("div.user-phone-fields").hide("fade", {}, "slow")
    )

  $("div#user-phones").on("click", "li a.phone-type", ->
    setParentDropdownMenu(@)
    $(@).parent().dropdown("toggle")
    return false
    )

  setParentDropdownMenu = (elm) ->
    str = $(elm).text()
    $(elm).parents("div.user-phone-fields").find("input.phone-kind").val(str.toLowerCase())
    $(elm).parents("div.input-group-btn").children("button.dropdown-toggle").html(str + " <span class='caret'></span>")

