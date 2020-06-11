leftSlide = function () {
  $(".slideImage2").animate({
    left: "0%"
  }, 500, function () {
    $(this).addClass('slideImage1');
    $(this).removeClass('slideImage2');
  });
  $(".slideImage1").animate({
    left: "-100%"
  }, 500, function () {
    $(this).addClass('slideImage2');
    $(this).removeClass('slideImage1');
    $(this).css("left", "100%");
  });
  setTimeout(function () {
    $(".slide__circles__left, .slide__circles__right").toggleClass("bright");
  }, 300);
}
$(function () {
  if ($(window).width() > 767) {
    // 一定時間で自動で左にスライドする処理
  setInterval(leftSlide, 15000);
  
  }
  
})