require "minitest/autorun"
require_relative "../lib/drink_manager"

class DrinkManagerTest < Minitest::Test
  def setup
    @drink_manager = DrinkManager.new
  end

  def test_produce_drink
    assert Drink.public_methods.include?(:coke)
    assert Drink.public_methods.include?(:water)
    assert Drink.public_methods.include?(:redbull)
  end

  def test_list
    assert_equal({Drink.coke => [120, 5], Drink.water => [100, 5], Drink.redbull => [200, 5]}, @drink_manager.list)
  end

  def test_stock
    assert_equal 5, @drink_manager.stock(Drink.coke)
  end
  def test_stock_when_no_drink
    assert_equal 0, @drink_manager.stock(Drink.new(:orange, 110))
  end
  def test_stock_when_no_stock
    @drink_manager.instance_variable_set(:@list, {Drink.coke => []})
    assert_equal 0, @drink_manager.stock(Drink.coke)
  end

  def test_purchasable_when_coke_and_sufficient_money
    assert @drink_manager.purchasable?(Drink.coke, 120)
  end
  def test_purchasable_when_coke_and_insufficient_money
    refute @drink_manager.purchasable?(Drink.coke, 100)
  end
  def test_purchasable_when_not_stock_drink
    refute @drink_manager.purchasable?(Drink.new(:orange, 110), 120)
  end

  def test_purchasable_list_when_sufficient_money
    assert_equal [Drink.coke, Drink.water, Drink.redbull], @drink_manager.purchasable_list(200)
  end
  def test_purchasable_list_when_insufficient_money
    assert_equal [], @drink_manager.purchasable_list(50)
  end

  def test_store_when_coke
    assert_equal 6, @drink_manager.store(Drink.coke)
    assert_equal 6, @drink_manager.stock(Drink.coke)
  end
  def test_store_when_not_stock_drink
    assert_equal 1, @drink_manager.store(Drink.new(:orange, 110))
    assert_equal Drink.new(:orange, 100), Drink.orange
  end
  def test_store_when_not_drink
    refute @drink_manager.store(:coke)
  end

  def test_extract_when_sufficient_drink
    assert_equal Drink.coke, @drink_manager.extract(Drink.coke)
    assert_equal 4, @drink_manager.stock(Drink.coke)
  end
  def test_extract_when_insufficient_drink
    @drink_manager.instance_variable_set(:@list, {Drink.coke => []})
    refute @drink_manager.extract(Drink.coke)
  end
  def test_extract_when_no_stock_drink
    refute @drink_manager.extract(Drink.new(:orange, 110))
  end
end
