$(document).ready(function(){
  ResizedElements.init();
  window.onresize = function(){
    if(window.innerWidth < 500){
      ResizedElements.init();
    } else {
      ResizedElements.init();
    }
  }
});

var ResizedElements = {
  init: function(){
    ResizedElements.take_action();
  },
  take_action: function(){
    var all_classes = [
      "header-logo",
      "tagline"
    ];
    if(window.innerWidth < 500){
      ResizedElements.add_mobile_opt(all_classes);
    } else {
      ResizedElements.remove_mobile_opt(all_classes);
    };
  },
  add_mobile_opt: function(classes){
    for(i=0 ; i < classes.length ; i++){
      var this_class = classes[i]
      $('.'+this_class).addClass(this_class+'-mobile-opt');
    }
  },
  remove_mobile_opt: function(classes){
    for(i=0 ; i < classes.length ; i++){
      var this_class = classes[i]
      $('.'+this_class).removeClass(this_class+'-mobile-opt');
    }
  }
}

var Admin = {
  init: function(){
    var admin_thumb_2 = $('.admin_img_magnifier')
    var admin_thumb_2_orig_size = admin_thumb_2.css('width')
    admin_thumb_2.hover(
      function(){
        $(this).stop().animate({'width':'400px'})
      }, function(){
        $(this).stop().animate({'width':admin_thumb_2_orig_size})
      }
    )
  }
}