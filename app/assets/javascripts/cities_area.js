$(document).ready(function(){
  $("div.viet-nam").click(function(){
    $(window).scrollTop($('.vietnam-area').offset().top);
  });
  $("div.international").click(function(){
    $(window).scrollTop($('.international-area').offset().top);
  });
});
