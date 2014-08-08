jQuery ->
  $("div.gal-item div.gal-inner-holder").on('click', (e) ->
    url = $(@).parents('div.gal-item').data('url')
    ckeditor_func_num = parseInt $("input#ckeditor_func_num").val()

    window.opener.CKEDITOR.tools.callFunction(ckeditor_func_num, url)
    window.close()
    )

  $("a#close-window").click ->
    window.close()
