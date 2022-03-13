require "minitest/autorun"
require_relative "../lib/cash_manager"

class CashManagerTest < Minitest::Test
  def setup
    @drink_manager = DrinkManager.new
    @cash_manager = CashManager.new(@drink_manager)
  end

  def test_insert_when_correct_money
    refute @cash_manager.insert(100)
    assert_equal 100, @cash_manager.amount
  end
  def test_insert_when_incorrect_money
    assert_equal 1, @cash_manager.insert(1)
    assert_equal 0, @cash_manager.amount
  end

  def test_refund_when_amount_100
    @cash_manager.insert(100)
    assert_equal 100, @cash_manager.refund
    assert_equal 0, @cash_manager.amount
  end
  def test_refund_when_amount_0
    assert_equal 0, @cash_manager.refund
    assert_equal 0, @cash_manager.amount
  end

  def test_purchasable_when_coke_and_sufficient_money
    @cash_manager.insert(100)
    2.times{@cash_manager.insert(10)}
    assert @cash_manager.purchasable?(:coke)
  end
  def test_purchasable_when_coke_and_insufficient_money
    @cash_manager.insert(100)
    refute @cash_manager.purchasable?(:coke)
  end
  def test_purchasable_when_not_stock_drink
    @cash_manager.insert(100)
    2.times{@cash_manager.insert(10)}
    refute @cash_manager.purchasable?(:orange)
  end

  def purchase_test_when_sufficient_money_and_sufficient_drink
    @cash_manager.insert(500)
    assert_equal [Drink.coke, 380], @cash_manager.purchase(:coke)
    assert_equal 380, @cash_manager.sale_amount
    assert_equal 0, @cash_manager.amount
  end
  def purchase_test_when_insufficient_money_and_sufficient_drink
    @cash_manager.insert(100)
    refute @cash_manager.purchase(:coke)
    assert_equal 0, @cash_manager.sale_amount
    assert_equal 100, @cash_manager.amount
  end
  def purchase_test_when_sufficient_money_and_insufficient_drink
    @cash_manager.insert(500)
    5.times{ @drink_manager.extract }
    refute @cash_manager.purchase(:coke)
    assert_equal 0, @cash_manager.sale_amount
    assert_equal 500, @cash_manager.amount
  end

  def test_purchasable_list_when_sufficient_money
    2.times{@cash_manager.insert(100)}
    assert_equal [:coke, :water, :redbull], @cash_manager.purchasable_list
  end
  def test_purchasable_list_when_insufficient_money
    2.times{@cash_manager.insert(10)}
    assert_equal [], @cash_manager.purchasable_list
  end
end
