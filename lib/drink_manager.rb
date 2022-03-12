require_relative "drink"

class DrinkManager
  def initialize(initial_list = [[:coke, 120, 5], [:water, 100, 5], [:redbull, 200, 5]])
    @drinks = Hash.new{|hash, key| hash[key] = []}
    initial_list.each {|name, price, _| produce_drink(name, price)}
    initial_list.each{|name, _, count| @drinks[Drink.send(name)] = [Drink.send(name)] * count}
  end

  def list
    list = {}
    @drinks.each do |drink, stock|
      list[drink] = [drink.price, stock.size]
    end
    list
  end

  def stock(drink)
    @drinks[drink].size
  end

  # listにないドリンクの場合、Drinkクラスにそのドリンク名のクラスメソッドを作成する
  def store(drink, count = 1)
    if drink.instance_of?(Drink)
      produce_drink(drink.name, drink.price) unless @drinks.key?(drink)
      count.times{@drinks[drink] << drink}
      stock(drink)
    end
  end

  def extract(drink)
    @drinks[drink].shift if stock(drink) > 0
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
