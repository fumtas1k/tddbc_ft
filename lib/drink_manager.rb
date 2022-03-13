require_relative "drink"

class DrinkManager
  def initialize(initial_list = [[:coke, 120, 5], [:water, 100, 5], [:redbull, 200, 5]])
    @drinks = produce_drinks(initial_list)
  end

  def exist?(name)
    Drink.respond_to?(name)
  end

  def list
    list = {}
    @drinks.each do |name, stock|
      list[name] = [price(name), stock(name)]
    end
    list
  end

  def price(name)
    if Drink.respond_to?(name)
      Drink.send(name).price
    end
  end

  def stock(name)
    @drinks[name].size
  end

  # listにないドリンクの場合、Drinkクラスにそのドリンク名のクラスメソッドを作成する
  def store(drink, count = 1)
    if drink.instance_of?(Drink)
      produce_drink(drink.name, drink.price) unless @drinks.key?(drink.name)
      count.times{@drinks[drink.name] << drink}
      stock(drink.name)
    end
  end

  def extract(name)
    @drinks[name].shift if stock(name) > 0
  end

  private
  # Drinkクラスにname, priceとなるインスタンスを作成する、nameという名前のクラスメソッドを新規で定義
  # 例えば、name = :coke, price = 120とすると、Drink.new(:coke, 120)がDrink.cokeで実行できる
  def produce_drink(name, price)
    Drink.define_singleton_method(name) do
      Drink.new(name, price)
    end
  end

  def produce_drinks(initial_list)
    # 初期値を空のArrayとしたHashを準備
    drinks = Hash.new{|hash, key| hash[key] = []}
    # Drink.名前のクラスメソッドを作成
    initial_list.each{|name, price, _| produce_drink(name, price)}
    # drinksにnameをkeyとし、Drinkクラスのインスタンスを配列にしたHashを生成
    initial_list.each{|name, _, count| drinks[name] += [Drink.send(name)] * count}
    drinks
  end
end
