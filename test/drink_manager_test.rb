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

  def test_stock_list
    assert_equal({:coke => [120, 5], :water => [100, 5], :redbull => [200, 5]}, @drink_manager.stock_list)
  end

  def test_exist_when_drink_exist
    assert @drink_manager.exist?(:coke)
  end

  def test_exist_when_no_drink
    refute @drink_manager.exist?(:apple)
  end

  def test_price
    assert_equal 120, @drink_manager.price(:coke)
  end

  def test_price_when_no_drink
    assert_equal nil, @drink_manager.price(:apple)
  end

  def test_stock
    assert_equal 5, @drink_manager.stock(:coke)
  end

  def test_stock_when_no_drink
    assert_equal 0, @drink_manager.stock(:orange)
  end

  def test_stock_when_no_stock
    @drink_manager.instance_variable_set(:@drinks, {:coke => []})
    assert_equal 0, @drink_manager.stock(:coke)
  end

  def test_store_when_coke
    assert_equal 6, @drink_manager.store(Drink.coke)
    assert_equal 6, @drink_manager.stock(:coke)
  end

  def test_store_when_not_stock_drink
    assert_equal 1, @drink_manager.store(Drink.new(:orange, 110))
    assert_equal Drink.new(:orange, 100), Drink.orange
  end

  def test_store_when_not_drink
    refute @drink_manager.store(:coke)
  end

  def test_extract_when_sufficient_drink
    assert_equal Drink.coke, @drink_manager.extract(:coke)
    assert_equal 4, @drink_manager.stock(:coke)
  end

  def test_extract_when_insufficient_drink
    @drink_manager.instance_variable_set(:@drinks, {:coke => []})
    refute @drink_manager.extract(:coke)
  end

  def test_extract_when_no_stock_drink
    refute @drink_manager.extract(:orange)
  end
end
