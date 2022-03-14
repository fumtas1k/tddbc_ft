require_relative "drink_manager"
require_relative "money"

class CashManager
  attr_reader :amount, :sale_amount

  MONEY = [10, 50, 100, 500, 1000].freeze

  def initialize(drink_manager)
    @amount = 0
    @sale_amount = 0
    @drink_manager = drink_manager
  end

  def insert(money)
    if money.to_s =~ /\A[1-9]\d*\z/ && MONEY.include?(money.to_i)
      @amount += money.to_i
      return
    else
      money
    end
  end

  def refund
    @amount, temp = 0, @amount
    temp
  end

  def purchasable?(name)
    if @drink_manager.exist?(name)
      @drink_manager.price(name) <= amount && @drink_manager.stock(name) > 0
    end
  end

  def purchase(name)
    if purchasable?(name)
      @sale_amount += @drink_manager.price(name)
      @amount -= @drink_manager.price(name)
      [@drink_manager.extract(name), refund]
    end
  end

  def purchasable_list
    @drink_manager.stock_list.keys.select{|name| purchasable?(name)}
  end

  private
  def self.produce_all_money
    [[:c, 1], [:c, 5], [:c, 10], [:c, 50],
    [:c, 100], [:c, 500], [:b, 1000],
    [:b, 2000], [:b, 5000], [:b, 10000]].each do |value, material|
      Money.produce_money(value, material)
  end
end
