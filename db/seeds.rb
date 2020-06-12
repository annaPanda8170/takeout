require 'net/http'
require 'date'
require 'json'
restaurant = Restaurant.new(
  {
    email: "a@a",
    name: "テストレストラン",
    password: "123123123",
    category: 0
  }
)
minute = [0,15,30,45]
restaurant.build_place(
  {
    address: "日本、〒999-9999 東京都東京区東京99丁目99−番99号",
    latitude: rand(35.59..35.76),
    longitude: rand(139.61..139.76),
    start: "#{rand(0..12)}:#{minute[rand(0..3)]}",
    last: "#{rand(13..23)}:#{minute[rand(0..3)]}"
  }
)
restaurant.save

75.times do 
  restaurant = Restaurant.new(
    {
      email: Faker::Internet.email,
      name: Faker::Restaurant.name,
      image: open("./app/assets/images/restaurant/restaurant#{rand(0..43)}.jpeg"),
      # discription: Faker::Restaurant.description ,
      password: "123123123",
      category: rand(0..21)
    }
  )
  latitude = rand(35.59..35.76)
  longitude = rand(139.61..139.76)
  url = URI.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{latitude},#{longitude}&key=AIzaSyCp8SWHBXhljWoY4oGAJ6WTAWGbTN4YF3I&language=ja")
  https = Net::HTTP.new(url.host, url.port)
  https.use_ssl = true
  req = Net::HTTP::Get.new(url)
  res = https.request(req)
  @hash = JSON.parse(res.body)
  restaurant.build_place(
    {
      address: @hash["results"][1]["formatted_address"],
      latitude: latitude,
      longitude: longitude,
      start: "#{rand(0..12)}:#{minute[rand(0..3)]}",
      last: "#{rand(13..23)}:#{minute[rand(0..3)]}"
    }
  )
  restaurant.save
  rand(3..8).times do 
    Cuisine.create(
      {
        name: Faker::Food.dish,
        discription: Faker::Food.description,
        image: open("./app/assets/images/cuisines/cuisine#{rand(0..27)}.jpg"),
        price: rand(5..28) * 100,
        restaurant_id: restaurant.id,
        cook_time: rand(10..60)
      }
    )
  end
end