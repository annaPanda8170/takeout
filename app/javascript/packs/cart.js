// なぜ$(this).data("id")がjでダメなのか未理解
$(function () {
  if (!$("#data").data("login")) {
    for (i = 0; i < $(".cuisine").length; i++){
      let $cuisine = $(`#cuisine${i}`)
      let data_id = $cuisine.data("id")
      $cuisine.append(`
      <input type="hidden" name="cart[carts_cuisines_attributes][${i}][cuisine_id]" id="cart_carts_cuisines_attributes_${i}_cuisine_id" value="${data_id}">
      <div class="button" id=button_${i}_0 data-id=${i} data-which=0>-</div>
      <input type="number" name="cart[carts_cuisines_attributes][${i}][number]" id="cart_carts_cuisines_attributes_${i}_number" class="cuisine__bottom__number" min=0 value=0 >
      <div class="button" id=button_${i}_1 data-id=${i} data-which=1">+</div>`)
    }
    for (j = 0; j < $(".cuisine").length; j++){
      $(`#button_${j}_0`).click(function () {
        let num = Number($(`#cart_carts_cuisines_attributes_${$(this).data("id")}_number`).val()) - 1
        if (num < 0) {
          num = 0
        } else {
          $("#cuisinesTotal").text(Number($("#cuisinesTotal").text()) - Number($(`#cuisine${$(this).data("id")}`).data("price")))
        }
        $(`#cart_carts_cuisines_attributes_${$(this).data("id")}_number`).val(num)
      })
      $(`#button_${j}_1`).click(function () {
        $(`#cart_carts_cuisines_attributes_${$(this).data("id")}_number`).val(Number($(`#cart_carts_cuisines_attributes_${$(this).data("id")}_number`).val())+1)
        $("#cuisinesTotal").text(Number($("#cuisinesTotal").text()) + Number($(`#cuisine${$(this).data("id")}`).data("price")))
      })
    }
  }
  
})


