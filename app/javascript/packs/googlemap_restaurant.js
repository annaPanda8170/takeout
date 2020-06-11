$(function () {
  $("#place_start").change(function () {
    if ($("#place_last").val() < $(this).val()) {
      $(this).val($("#place_last").val())
    }
  })
  $("#place_last").change(function () {
    if ($("#place_start").val() > $(this).val()) {
      $(this).val($("#place_start").val())
    }
  })
  $(".geolocation__button").click(function () {
    if (navigator.geolocation) {
      $(".geolocation__button").text("取得中...")
      $(".arrow").fadeOut();
      navigator.geolocation.getCurrentPosition(
        function(position) {
          let lat = position.coords.latitude;
          let lng = position.coords.longitude;
              // window.location.href = `/"something"/searches?latitude=${lat}&longitude=${lng}`
          $("form").prepend(
            `<input value=${lat} type="hidden" name="place[latitude]" id="place_latitude">
            <input value=${lng} type="hidden" name="place[longitude]" id="place_longitude">`)
          let url = `https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lng}&key=AIzaSyCp8SWHBXhljWoY4oGAJ6WTAWGbTN4YF3I`
          $.getJSON(url)
            .then((data) => {
            $("#address").val(data.results[1].formatted_address);
            })
            $(".geolocation__button").text("↓ 必要があれば住所を修正してください")
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
})