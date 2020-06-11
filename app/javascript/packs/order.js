function searchTime(lat1, lng1) {
  let lat2 = $("#data_set").data("lat2");
  let lng2 = $("#data_set").data("lng2");
  $.ajax({
    url: `/orders/get_directions`,
    type: "GET",
    dataType: 'json',
    data: {
      lat1: lat1,
      lng1: lng1,
      lat2: lat2,
      lng2: lng2
    }
  }).done(function (data) {
    let walkText = data.walk.routes[0].legs[0].duration.text
    let driveText = data.drive.routes[0].legs[0].duration.text
    walkText = walkText.replace("hours", "時").replace("hour", "時").replace("mins", "分")
    driveText = driveText.replace("hours", "時").replace("hour", "時").replace("mins", "分")
    console.log(walkText)
    $("#walk").text(walkText)
    $("#drive").text(driveText)
    // console.log(data.walk.routes[0].legs[0].duration.value)
    // console.log(data.drive.routes[0].legs[0].duration.value)
  })
}


$(function () {
  
  
  for (i = 0; i < $(".orderCuisine").length; i++){
    let $cuisine = $(`#cuisine${i}`)
    let data_id = $cuisine.data("id")
    let data_number = $cuisine.data("number")
    let data_price = $cuisine.data("price")
    $cuisine.append(`
    <input type="hidden" name="order[orders_cuisines_attributes][${i}][cuisine_id]" id="order_orders_cuisines_attributes_${i}_cuisine_id" class="cuisinehidden" data-price=${data_price} data-id=${i} value="${data_id}">`)
    $(`#cuisine${i}  .orderCuisine__priceNumber__price`).append(`<input type="number" min=0 name="order[orders_cuisines_attributes][${i}][number]" data-id=${i} id="order_orders_cuisines_attributes_${i}_number" style="border-color: darkred" class="cuisine_number" value="${data_number}">`)
  }
  $("#order_start").change(function () {
    if ($(this).val() <  $("#data_set").data("fasttime")) {
      $(this).val( $("#data_set").data("fasttime"))
    }
  })
  $(".cuisine_number").change(function (e) {
    let total = 0
    $(".cuisinehidden").each(function (e) {
      total += $(this).data("price") * $(`#order_orders_cuisines_attributes_${$(this).data("id")}_number`).val()
    })
    $("#total").text(total);
  })
  $(".orderCuisine__link").click(function () {
    $(`#cuisine${$(this).data("id")}`).remove()
    let total = 0
    $(".cuisinehidden").each(function (e) {
      total += $(this).data("price") * $(`#order_orders_cuisines_attributes_${$(this).data("id")}_number`).val()
    })
    $("#total").text(total);
  })
  $("#payNew__geolocation__button").click(function () {
    if (navigator.geolocation) {
      $("#payNew__geolocation__button").text("計測中...")
      navigator.geolocation.getCurrentPosition(
        function(position) {
          let lat1 = position.coords.latitude;
          let lng1 = position.coords.longitude;
          $.ajax({
            url: `/orders/post_latlng`,
            type: "GET",
            dataType: 'json',
            data: {
              lat: lat1,
              lng: lng1
            }
          })
          searchTime(lat1, lng1)
          $(".rightContainer__geolocation").css({ display: "none" })
          $(".rightContainer__answer").css({display: "block"})
        },
        function (error) {
          let errorInfo = [
            "原因不明のエラーが発生しました。" ,
            "位置情報の取得が許可されませんでした。" ,
            "電波状況などで位置情報が取得できませんでした。" ,
            "位置情報の取得に時間がかかり過ぎてタイムアウトしました。"
          ] ;
          //エラーコードを変数に代入（エラーコードはgetCurrentPositionの引数として受け取っている）
          let errorNo = error.code ;
          //エラーメッセージに、先に定義したエラーコードと、エラー番号に対応した情報をalert表示させる
          let errorMessage = "[エラー番号: " + errorNo + "]\n" + errorInfo[ errorNo ] ;
          alert( errorMessage ) ;
        } ,
        //オプション設定（10秒でタイムアウトになる）
        {
          "enableHighAccuracy": false,
          "timeout": 10000,
          "maximumAge": 0,
          }
        );
    }
    //ユーザーのブラウザがGeolocation APIに対応していなかった場合の処理
    else {
      let errorMessage = "お使いの端末は、GeoLacation APIに対応していません。" ;
      alert( errorMessage ) ;
    }
  })
  // なぜかJSからは取れない(Access-Control-Allow-Origin)ので仕方なく、Controller経由にて
  if ($("#data_set").data("lat1")) {
    $("#payNew__geolocation__button").text("距離計算中...")
    let lat1 = $("#data_set").data("lat1");
    let lng1 = $("#data_set").data("lng1");
    searchTime(lat1, lng1)
    $(".rightContainer__geolocation").css({ display: "none" })
    $(".rightContainer__answer").css({display: "block"})
  }
  

})