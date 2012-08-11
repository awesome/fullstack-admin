$.fn.extend({

  sticky : function(opts){

    var $window    = $(window),
        topPadding = opts.paddingTop === undefined ? 0 : opts.paddingTop,
        afterOffset  = (opts.after && $(opts.after).length > 0) ?  ($(opts.after).offset().top + $(opts.after).height()) : 0,
        moveTo     = topPadding + afterOffset,
        klass      = opts.addClass || "sticky";
		
     $(this).each(function(){
        var $elem      = $(this),
            offset     = $elem.offset()

        $window.scroll(function() {
          if ($window.scrollTop() > (offset.top - afterOffset)) {
              if(klass){
                $elem.addClass(klass);
              }
			  if ($("#sticky-body-height-workaround").length == 0) {
				  var workaround = $('<div id="sticky-body-height-workaround"></div>');
				  workaround.css({ 
					  height: $elem.outerHeight(true),
					  visibility: 'hidden',
					  clear: 'both'
				  });
				  $("body").append(workaround);
			  };
              $elem.css({position: "fixed", top: moveTo});
          } else {
              if(klass){
                $elem.removeClass(klass);
              }
			  $("#sticky-body-height-workaround").remove();
              $elem.css({position: "static", top: 0});
          }
        }); // ~ window.scroll
    }); // ~ each
  } // ~ sticky

});

