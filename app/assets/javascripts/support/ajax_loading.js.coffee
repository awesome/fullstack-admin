$(document).ready ->
  $(document).ajaxStart ->
    $("body").append "<div id=\"ajax-loading\"><div class=\"loading\">Caricamento...</div></div>"  if $("#ajax-loading").length is 0
    $("#ajax-loading").show()

  $(document).ajaxStop ->
    $("#ajax-loading").hide()
