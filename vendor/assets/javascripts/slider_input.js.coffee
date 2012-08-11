(($) ->
  $.fn.extend 
    sliderInput: ->
      $(this).each (i, e) ->
        input   = $(this)
        input.hide()

        slider  = $('<div class="slider-widget"/>')
        label   = $('<div class="slider-label"/>')
        parent  = $('<div class="slider-input">')
  
        parent.append(slider).append(label)
        input.after(parent)
  
        value = input.val()
        min   = input.data('range-min')
        max   = input.data('range-max')
        step  = input.data('step')
  
        slider.slider
          value: value
          min: min
          max: max
          step: step
          slide: ( event, ui ) ->
            input.val  ui.value 
            label.text "" + ui.value + "/" + max
        
        label.text "" + value + "/" + max

) jQuery
