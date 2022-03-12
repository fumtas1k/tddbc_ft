require "minitest/autorun"
require_relative "../lib/drink"

class DrinkTest < Minitest::Test
  def setup
    @coke = Drink.new(:coke, 120)
  end

  def test_inspect
    assert_equal @coke.inspect, @coke.name
  end
  def test_to_s
    assert_equal @coke.to_s, @coke.name.to_s
  end

  def test_eql_when_same_drink_and_same_class
    assert @coke.eql?(Drink.new(:coke, 120))
  end
  def test_eql_when_different_drink_and_same_class
    refute @coke.eql?(Drink.new(:water, 100))
  end
  def test_eql_when_different_drink_and_different_class
    refute @coke.eql?(:coke)
  end

  def test_equal_when_same_drink_and_same_class
    assert @coke == Drink.new(:coke, 120)
  end
  def test_equal_when_different_drink_and_same_class
    refute @coke == Drink.new(:water, 100)
  end
  def test_eql_when_different_drink_and_different_class
    refute @coke == :coke
  end
end
