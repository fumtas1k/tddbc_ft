require_relative "drink"

class DrinkManager
  def initialize
    @list = Hash.new{|hash, key| hash[key] = []}
    initial_list = [[:coke, 120], [:water, 100], [:redbull, 200]]
    initial_list.each {|name, price| produce_drink(name, price)}
    initial_list.each{|name, _| @list[Drink.send(name)] = [Drink.send(name)] * 5}
  end

  def list
    list = {}
    @list.each do |drink, stock|
      list[drink] = [drink.price, stock.size]
    end
    list
  end

  def stock(drink)
    @list[drink].size
  end

  def purchasable?(drink, money)
    drink.instance_of?(Drink) && drink.price <= money.to_i && stock(drink) > 0
  end

  def purchasable_list(money)
    @list.keys.select{|drink| drink.price <= money.to_i}
  end

  # listにないドリンクの場合、Drinkクラスにそのドリンク名のクラスメソッドを作成する
  def store(drink)
    if drink.instance_of?(Drink)
      produce_drink(drink.name, drink.price) unless @list.key?(drink)
      @list[drink] << drink
      stock(drink)
    end
  end

  def extract(drink)
    @list[drink].shift if stock(drink) > 0
  end

  private
  # Drinkクラスにname, priceとなるインスタンスを作成する、nameという名前のクラスメソッドを新規で定義
  # 例えば、name = :coke, price = 120とすると、Drink.new(:coke, 120)がDrink.cokeで実行できる
  def produce_drink(name, price)
    Drink.define_singleton_method(name) do
      Drink.new(name, price)
    end
  end
end
