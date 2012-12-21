# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('.remove-sub-unit').click ->
    remove_sub_unit(this)

  $('.add-sub-unit-button').click ->
    add_sub_unit(this)

  $('select#organization_unit_type').change ->
    unit_type = $(@).val()
    sub_unit_type = JSON.parse(window.unit_types)[unit_type]
    $('.unit-type').text(sub_unit_type)
    $('.unit-type-plural').text(sub_unit_type + "s")

  add_sub_unit = (link) ->
    new_sub_unit = $(".hidden#new-sub-unit-fields").html()
    new_id = new Date().getTime()
    regexp = new RegExp("new_sub_unit", "g")
    $(link).closest('.add-sub-unit').before(new_sub_unit.replace(regexp, new_id))
    $(link).closest('.add-sub-unit').prev().find('input[type=text]').focus()


  remove_sub_unit = (link) ->
    $(link).prev("input[type=hidden]").val("1")
    $(link).closest(".control-group").hide()

  $('a.create-my-unit').click ->
    # remove duplicate form values
    uniqueNames = []
    $.each($('.controls.sub-unit input[type=text]'), (i, el) ->
        if $.inArray($(this).val(), uniqueNames) == -1
          uniqueNames.push($(this).val())
        else
          $(this).parent().find('input[type=hidden]').val("true")
      )
    # alert uniqueNames
    # alert $(this).parent()
    $(this).closest('form').submit()
