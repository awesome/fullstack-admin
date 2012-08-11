(($) ->
  $.fn.extend 
    limit: ->
      $(this).each (i, e) ->
        input = $(this)
        limit = $(this).data("limit")
        label = $(this).closest("*:has(label)").find("label")
        horizontal = ($(this).closest(".form-horizontal").length > 0)
        counter = undefined
        counter = $("<span class=\"badge badge-info badge-mini\" data-tip=\"Caratteri disponibili\">" + limit + "</span>")
        if horizontal
          label.append "<br/>"
        else
          label.append " "
        label.append counter
        
        element = counter
        interval = undefined
        f = undefined
        self = $(this)
        $(this).focus ->
          interval = window.setInterval(substring, 100)

        $(this).blur ->
          clearInterval interval
          substring()

        substringFunction = "function substring(){ var val = $(self).val();var length = val.length;if(length > limit){$(self).val($(self).val().substring(0,limit));}"
        substringFunction += "if($(element).html() != limit-length){$(element).html((limit-length<=0)?'0':limit-length);}"  unless typeof element is "undefined"
        substringFunction += "}"
        eval substringFunction
        substring()
) jQuery

