$(function () {
  
  if ($(window).width() > 767) {
    $(".header__cart, .header__hover").hover(function () {
      $(".header__hover").css({display: "block"})
    }, function () {
      $(".header__hover").css({display: "none"})
    })
  } else {
    $(".header__cart").click(function (e) {
      e.preventDefault();
      $(".header__hover").css({ display: "block" });
      $(".header__hover").animate({ right: "0px" });
    })
    $(document).click(function (event) {
      if ($(event.target).closest('.header__cart').length == 0
      && $(event.target).closest('.header__hover').length == 0) {
        $(".header__hover").css({ display: "none" });
        $(".header__hover").animate({ right: "-600px" });
      } else {
      }
    });
  }
})