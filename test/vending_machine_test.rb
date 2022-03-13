require "minitest/autorun"
require_relative "../lib/vending_machine"

class VendingMachineTest < Minitest::Test
  def setup
    @vending_machine = VendingMachine.new
  end

  # DrinkManagerの機能確認
  def test_produce_drink
    assert Drink.public_methods.include?(:coke)
    assert Drink.public_methods.include?(:water)
    assert Drink.public_methods.include?(:redbull)
  end

  def test_list
    assert_equal({:coke => [120, 5], :water => [100, 5], :redbull => [200, 5]}, @vending_machine.list)
  end

  def test_exist_when_drink_exist
    assert @vending_machine.exist?(:coke)
  end

  def test_exist_when_no_drink
    refute @vending_machine.exist?(:apple)
  end

  def test_price
    assert_equal 120, @vending_machine.price(:coke)
  end

  def test_price_when_no_drink
    assert_equal nil, @vending_machine.price(:apple)
  end

  def test_stock
    assert_equal 5, @vending_machine.stock(:coke)
  end

  def test_stock_when_no_drink
    assert_equal 0, @vending_machine.stock(:orange)
  end

  def test_stock_when_no_stock
    5.times{@vending_machine.extract(:coke)}
    assert_equal 0, @vending_machine.stock(:coke)
  end

  def test_store_when_coke
    assert_equal 6, @vending_machine.store(Drink.coke)
    assert_equal 6, @vending_machine.stock(:coke)
  end

  def test_store_when_not_stock_drink
    assert_equal 1, @vending_machine.store(Drink.new(:orange, 110))
    assert_equal Drink.new(:orange, 100), Drink.orange
  end

  def test_store_when_not_drink
    refute @vending_machine.store(:coke)
  end

  def test_extract_when_sufficient_drink
    assert_equal Drink.coke, @vending_machine.extract(:coke)
    assert_equal 4, @vending_machine.stock(:coke)
  end

  def test_extract_when_insufficient_drink
    5.times{@vending_machine.extract(:coke)}
    refute @vending_machine.extract(:coke)
  end

  def test_extract_when_no_stock_drink
    refute @vending_machine.extract(:orange)
  end

  # CashManagerの機能確認
  def test_insert_when_correct_money
    refute @vending_machine.insert(100)
    assert_equal 100, @vending_machine.amount
  end

  def test_insert_when_incorrect_money
    assert_equal 1, @vending_machine.insert(1)
    assert_equal 0, @vending_machine.amount
  end

  def test_refund_when_amount_100
    @vending_machine.insert(100)
    assert_equal 100, @vending_machine.refund
    assert_equal 0, @vending_machine.amount
  end

  def test_refund_when_amount_0
    assert_equal 0, @vending_machine.refund
    assert_equal 0, @vending_machine.amount
  end

  def test_purchasable_when_coke_and_sufficient_money
    @vending_machine.insert(100)
    2.times{@vending_machine.insert(10)}
    assert @vending_machine.purchasable?(:coke)
  end

  def test_purchasable_when_coke_and_insufficient_money
    @vending_machine.insert(100)
    refute @vending_machine.purchasable?(:coke)
  end

  def test_purchasable_when_not_stock_drink
    @vending_machine.insert(100)
    2.times{@vending_machine.insert(10)}
    refute @vending_machine.purchasable?(:orange)
  end

  def purchase_test_when_sufficient_money_and_sufficient_drink
    @vending_machine.insert(500)
    assert_equal [Drink.coke, 380], @vending_machine.purchase(:coke)
    assert_equal 380, @vending_machine.sale_amount
    assert_equal 0, @vending_machine.amount
  end

  def purchase_test_when_insufficient_money_and_sufficient_drink
    @vending_machine.insert(100)
    refute @vending_machine.purchase(:coke)
    assert_equal 0, @vending_machine.sale_amount
    assert_equal 100, @vending_machine.amount
  end

  def purchase_test_when_sufficient_money_and_insufficient_drink
    @vending_machine.insert(500)
    5.times{ @drink_manager.extract }
    refute @vending_machine.purchase(:coke)
    assert_equal 0, @vending_machine.sale_amount
    assert_equal 500, @vending_machine.amount
  end

  def test_purchasable_list_when_sufficient_money
    2.times{@vending_machine.insert(100)}
    assert_equal [:coke, :water, :redbull], @vending_machine.purchasable_list
  end

  def test_purchasable_list_when_insufficient_money
    2.times{@vending_machine.insert(10)}
    assert_equal [], @vending_machine.purchasable_list
  end

end
