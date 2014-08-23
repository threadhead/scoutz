jQuery ->
  # $("input.search-meta").autocomplete({
  #   source: "/meta_search"
  #   })
  # .autocomplete("instance")._renderItem = (ul, item) ->
  #   a = ''
  #   a += "<div class='initial-circle initial-circle-meta-search initial-circle-#{item.resource}'>#{item.initials}</div>"
  #   a += "<strong>#{item.name}</strong><br>"
  #   a += "<small><em>#{item.desc}</em></small>"
  #   # a += "<hr class='hr-li-autocomplete'>"
  #   $("<li data-url='#{item.url}'>").append($(a)).appendTo(ul)
  toTitleCase = (str) ->
    str.replace(/\w\S*/g, (txt) ->
      txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()
    )


  $.widget "custom.catcomplete", $.ui.autocomplete,
    _create: ->
      @_super()
      @widget().menu "option", "items", "> :not(.ui-autocomplete-category)"

    _renderMenu: (ul, items) ->
      console.log '_renderMenu'
      that = this
      currentCategory = ""

      $.each items, (index, item) ->
        li = undefined
        unless item.resource == currentCategory
          ul.append "<li class='ui-autocomplete-category ui-menu-item'>" + toTitleCase(item.resource + 's') + "</li>"
          currentCategory = item.resource


        li = that._renderItemData(ul, item)
        # li.attr "aria-label", item.resource + " : " + item.name  if item.resource


    _renderItem: (ul, item) ->
      a = ''
      a += "<div class='initial-circle initial-circle-meta-search initial-circle-#{item.resource}'>#{item.initials}</div>"
      a += "<strong>#{item.name}</strong><br>"
      a += "<small><em>#{item.desc}</em></small>"
      # a += "<hr class='hr-li-autocomplete'>"
      $("<li data-url='#{item.url}'>").append($(a)).appendTo(ul)

  $("input.search-meta").catcomplete
    source: "/meta_search"
    select: (event, ui) ->
      # console.log event
      # console.log ui
      # console.log ui.item.url
      window.location.href = ui.item.url
    open: ->
      $(@).autocomplete("widget").width(300)


  # $.ui.autocomplete.prototype._resizeMenu = ->
  #   ul = this.menu.element
  #   ul.outerWidth(this.element.outerWidth())
