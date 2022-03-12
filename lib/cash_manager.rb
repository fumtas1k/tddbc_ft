require_relative "drink_manager"

class CashManager
  attr_reader :amount, :sale_amount
  MONEY = [10, 50, 100, 500, 1000].freeze
  def initialize(drink_manager)
    @amount = 0
    @sale_amount = 0
    @drink_manager = drink_manager
  end

  def insert(money)
    return money unless money.to_s =~ /\A[1-9]\d*\z/ && MONEY.include?(money.to_i)
    @amount += money.to_i
    return
  end

  def refund
    @amount, temp = 0, @amount
    temp
  end

  def purchasable?(drink)
    drink.instance_of?(Drink) && drink.price <= amount && @drink_manager.stock(drink) > 0
  end

  def purchase(drink)
    if purchasable?(drink)
      @sale_amount += drink.price
      @amount -= drink.price
      [@juice_manager.extract(drink), refund]
    end
  end

  def purchasable_list
    @drink_manager.list.keys.select{|drink| drink.price <= amount && @drink_manager.stock(drink) > 0}
  end
end
