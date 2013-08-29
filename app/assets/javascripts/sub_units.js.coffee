jQuery ->
  $('.well.sub-units').on('click', 'a.remove-sub-unit-button', ->
      removeSubUnit(@)
    )

  $('a.add-sub-unit-button').click ->
    addSubUnit(@)

  setSubUnitDisplay = (unit_type) ->
    sub_unit_type = JSON.parse(window.unit_types)[unit_type]
    $('.unit-type').text(sub_unit_type)
    $('.unit-type-plural').text(sub_unit_type + "s")
    unit_type_dash = unit_type.replace(/\s/g, '-').toLowerCase()
    # alert unit_type_dash
    $('span.sub-unit-type').hide()
    $('span.sub-unit-type#' + unit_type_dash).show()


  if $('span.sub-unit-type.help-block').length
    $('span.sub-unit-type').hide()
    $('span.sub-unit-type').removeClass('hidden')
    setSubUnitDisplay( $('select#unit_unit_type').val() )

  $('select#unit_unit_type').change ->
    unit_type = $(@).val()
    setSubUnitDisplay( unit_type )


  addSubUnit = (link) ->
    new_sub_unit = $(".hidden#new-sub-unit-fields").html()
    new_id = new Date().getTime()
    regexp = new RegExp("new_sub_unit", "g")
    $(link).closest('.add-sub-unit').before(new_sub_unit.replace(regexp, new_id))
    $(link).closest('.add-sub-unit').prev().find('input[type=text]').focus()


  removeSubUnit = (link) ->
    $(link).prev("input[type=hidden]").val("1")
    $(link).closest(".control-group").hide()

  $('a.create-my-unit').click ->
    # remove duplicate form values
    uniqueNames = []
    $.each($('.controls.sub-unit input[type=text]'), (i, el) ->
        if $.inArray($(@).val(), uniqueNames) == -1
          uniqueNames.push($(@).val())
        else
          $(@).parent().find('input[type=hidden]').val("true")
      )
    # alert uniqueNames
    # alert $(@).parent()
    $(@).closest('form').submit()
