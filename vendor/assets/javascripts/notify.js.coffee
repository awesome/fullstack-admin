//= require jquery.noty

$.notify =
  notice: (message) ->
    noty
      text: message
      layout: "topRight"
      type: "success"
      textAlign: "left"
      easing: "swing"
      animateOpen:
        height: "toggle"

      animateClose:
        height: "toggle"

      speed: "500"
      timeout: "10000"
      closable: true
      closeOnSelfClick: true

  error: (message) ->
    noty
      text: message
      layout: "topRight"
      type: "error"
      textAlign: "left"
      easing: "swing"
      animateOpen:
        height: "toggle"

      animateClose:
        height: "toggle"

      speed: "500"
      timeout: "10000"
      closable: true
      closeOnSelfClick: true

  alert: (message) ->
    noty
      text: message
      layout: "topRight"
      type: "alert"
      textAlign: "left"
      easing: "swing"
      animateOpen:
        height: "toggle"

      animateClose:
        height: "toggle"

      speed: "500"
      timeout: "10000"
      closable: true
      closeOnSelfClick: true

  warning: (message) ->
    @.alert(message)

  success: (message) ->
    @.notice(message)


this.notify_notice  = $.notify.notice
this.notify_error   = $.notify.error
this.notify_alert   = $.notify.alert
this.notify_warning = $.notify.warning
this.notify_success = $.notify.success