jQuery ->
  $("div.gal-item div.gal-inner-holder").on('click', (e) ->
    url = $(@).parents('div.gal-item').data('url')
    # console.log url
    ckeditor_func_num = parseInt $("input#ckeditor_func_num").val()
    # console.log ckeditor_func_num

    window.opener.CKEDITOR.tools.callFunction(ckeditor_func_num, url)
    window.close()
    )
