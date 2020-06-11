function distance(lat1, lng1, lat2, lng2) {
  lat1 *= Math.PI / 180;
  lng1 *= Math.PI / 180;
  lat2 *= Math.PI / 180;
  lng2 *= Math.PI / 180;
  return 6371 * Math.acos(Math.cos(lat1) * Math.cos(lat2) * Math.cos(lng2 - lng1) + Math.sin(lat1) * Math.sin(lat2));
}
$(function () {
  $(".geolocation__button").click(function () {
    if (navigator.geolocation) {
      $(".geolocation__button").text("読み込み中...")
      navigator.geolocation.getCurrentPosition(
        function(position) {
          let lat = position.coords.latitude;
          let lng = position.coords.longitude;
              // window.location.href = `/"something"/searches?latitude=${lat}&longitude=${lng}`
          $("form").prepend(
            `<input value=${lat} type="hidden" name="place[latitude]" id="place_latitude">
            <input value=${lng} type="hidden" name="place[longitude]" id="place_longitude">`)
          $.ajax({
            url: `/orders/post_latlng`,
            type: "GET",
            dataType: 'json',
            data: {
              lat: lat,
              lng: lng
            }
          })
          $.ajax({
            url: `/orders/get_restaurants`,
            type: "GET",
            dataType: 'json'
          }).done(function (data) {
            let resid_set = []
            let meter = $("#geolocation__meter").val();
            $.each(data.data, function (i, d) {
              if (distance(lat, lng, d.latitude, d.longitude) < meter) {
                resid_set.push(d.restaurant_id)
              }
            })
            $(`.restaurant`).css({ display: "none" })
            $.each(resid_set, function (i, e) {
              $(`#restaurant${e}`).css({display: "inline-block"})
            })
            $(".geolocation__button").text("再実行")
            if (resid_set.length == 0) {
              $("#restaurant__none").css({display: "block"})
            }
          })
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