require 'net/http'
require 'date'
require 'json'
class OrdersController < ApplicationController
  def index
    # binding.pry
    @ress = Restaurant.all
    # 以下3行のスマートなやり方がわからない
    @restaurants = []
    @ress.each do |r|
      @restaurants << r if r.cuisines.length != 0
    end
  end
  def get_directions
    url = URI.parse("https://maps.googleapis.com/maps/api/directions/json?origin=#{params[:lat1]},#{params[:lng1]}&destination=#{params[:lat2]},#{params[:lng2]}&mode=walking&key=AIzaSyCp8SWHBXhljWoY4oGAJ6WTAWGbTN4YF3I")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    req = Net::HTTP::Get.new(url)
    res = https.request(req)
    walk = JSON.parse(res.body)

    url = URI.parse("https://maps.googleapis.com/maps/api/directions/json?origin=#{params[:lat1]},#{params[:lng1]}&destination=#{params[:lat2]},#{params[:lng2]}&mode=driving&key=AIzaSyCp8SWHBXhljWoY4oGAJ6WTAWGbTN4YF3I")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    req = Net::HTTP::Get.new(url)
    res = https.request(req)
    drive = JSON.parse(res.body)

    respond_to do |format|
      format.json {render json:
        {walk: walk,
        drive: drive}
      }
    end

  end
  def get_restaurants
    @places = Place.all
    @data = []
    @places.each do |p|
      @data << p if p.restaurant.cuisines.length != 0
    end
    respond_to do |format|
      format.json {render json:
        {data: @data}
      }
    end
  end
  def post_latlng
    session[:lat] = params[:lat]
    session[:lng] = params[:lng]
  end
  def show
    @ress = Restaurant.where(category: params[:id])
    # 以下3行のスマートなやり方がわからない
    @restaurants = []
    @ress.each do |r|
      @restaurants << r if r.cuisines.length != 0
    end
    @category = Restaurant.categories.keys.to_a[params[:id].to_i]
  end
  def new
    @cuisines = Cuisine.where(restaurant_id: params[:format].to_i)
    @cart = Cart.new
    @cart.carts_cuisines.build
    # flash[:restaurant_id] = params[:format].to_i
    @restaurant = params[:format].to_i
    @login = restaurant_signed_in?
  end
  def create
    # pay_newに直接行く用
    
    cart = Cart.new(cart_params)
    cart.carts_cuisines.each do |d|
      if d.number == 0
        cart.carts_cuisines.delete(d)
      end  
    end
    @restaurant = cart.restaurant_id
    # flash[:restaurant_id] = cart.restaurant_id
    if cart.save
      # session[:cart]の中身は[[レストランid,[カートid]]]となってる
      if session[:cart] == nil
        session[:cart] = [[cart.restaurant_id, [cart.id]]] 
      else
        check = nil
        session[:cart].each_with_index do |s, i|
          if s[0] == cart.restaurant_id
            check = i
          end
        end
        if check
          session[:cart][check][1] << cart.id
        else
          session[:cart] << [cart.restaurant_id, [cart.id]]
        end
      end
      redirect_to root_path if params["which_submit"] == "買い物かごに入れて店舗一覧に戻る"
      redirect_to pay_new_orders_path(cart.restaurant_id) if params["which_submit"] == "会計"
    else
      @cart = Cart.new
      @cart.carts_cuisines.build
      render :new
    end
  end
  def pay_index
    @aaa = session[:cart]
    @bbb = "これこれ"
    @answer = []
    session[:cart].each do |c|
      @answerInner = [Restaurant.find(c[0])]
      @cuisines = []
      c[1].each do |cartid|
        @cuisines << Cart.find(cartid).carts_cuisines
      end
      @cuisines.flatten!
      @cuisineArray = []
      @cuisines.each do |c|
        if @cuisineArray[c.cuisine_id] == nil
          @cuisineArray[c.cuisine_id] = c.number
        else
          @cuisineArray[c.cuisine_id] += c.number
        end
      end
      @answerInner2 = []
      @cuisineArray.each_with_index do |c, i|
        if c
          @answerInner2 << [Cuisine.find(i), c]
        end
      end
      puts @answerInner2
      @answerInner << @answerInner2
      @answer << @answerInner
    end



  end
  def pay_new
    which_cart = nil
    # セッションの配列の中から今会計をするレストランのカートid情報をとる
    session[:cart].each do |s|
      if s[0] == params[:format].to_i
        which_cart = s[1]
      end
    end
    # カートをデータベースに取りに行く
    @carts = []
    which_cart.each do |wc|
      @carts << Cart.find(wc)
    end
    @cuisines = []
    @carts.each do |c|
      # 複数一度に取れることもある
      @cuisines << c.carts_cuisines
    end
    # 料理はダブってる
    @cuisines.flatten!
    @cuisine_number_set = []
    @cuisines.each do |c|
      if @cuisine_number_set[c.cuisine_id] == nil
        @cuisine_number_set[c.cuisine_id] = c.number
      else
        @cuisine_number_set[c.cuisine_id] += c.number
      end
    end
    # nilがいっぱいの配列だと使いにくいから整形
    @cuisine_number_array = []
    @cuisine_number_set.each_with_index do |c, i|
      if c
        @cuisine_number_array << [i, c]
      end
    end
    @restaurant = Restaurant.find(params[:format].to_i)
    @order = Order.new
    @order.orders_cuisines.build
    # flash[:restaurant_id] =  @restaurant.id
    @lat = session[:lat]
    @lng = session[:lng]
  end
  def pay_create
    @order = Order.new(order_params)
    if @order.save
      amount = 0
      @order.orders_cuisines.each do |o|
        amount += o.cuisine.price * o.number
      end
      Payjp.api_key = Rails.application.credentials.payjp
      buy_info = Payjp::Charge.create(
        amount: amount,
        card: params['payjp-token'],
        currency: 'jpy'
      )
      @order.update(card:buy_info.id)
      session[:cart].delete_if do |c|
        # c[0] == @order.cuisines[0].restaurant.idでやりたいができない
        c[0] == Cuisine.find(OrdersCuisine.find_by(order_id:@order.id).cuisine_id).restaurant_id
      end
      puts @order.id
      puts OrdersCuisine.find(@order.id).cuisine_id
      puts Cuisine.find(OrdersCuisine.find_by(order_id:@order.id).cuisine_id)
      puts Cuisine.find(OrdersCuisine.find_by(order_id:@order.id).cuisine_id).restaurant_id
      redirect_to root_path
    else
      render :pay_new
    end

  end
  def destroy
    carts = nil
    which_session = nil
    session[:cart].each_with_index do |c,i|
      if c[0] == params[:id].to_i
        carts = c[1]
        which_session = i
      end
    end
    carts.each do |cart|
      Cart.find(cart).delete
    end
    session[:cart].delete_at(which_session)
    redirect_to root_path
  end
  private
  def cart_params
    params.require(:cart).permit(:restaurant_id, carts_cuisines_attributes: [:cuisine_id, :number])
  end
  def order_params
    params.require(:order).permit(:time, :card, orders_cuisines_attributes: [:cuisine_id, :number])
  end
end
