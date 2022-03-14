require "minitest/autorun"
require_relative "../lib/money"

class MoneyTest < Minitest::Test
  def setup
    @c100 = Money.new(:c, 100)
    @b1000 = Money.new(:b, 1000)
  end

  def test_inspect
    assert_equal "Money.c100", @c100.inspect
  end
  def test_to_s
    assert_equal "Money.c100", @c100.to_s
  end

  def test_eql_when_same_money_and_same_class
    assert @c100.eql?(Money.new(:c, 100))
  end

  def test_eql_when_different_Money_and_same_class
    refute @c100.eql?(Money.new(:c, 10))
  end

  def test_eql_when_different_Money_and_different_class
    refute @c100.eql?(:c100)
  end

  def test_equal_when_same_Money_and_same_class
    assert @c100 == Money.new(:c, 100)
  end

  def test_equal_when_different_Money_and_same_class
    refute @c100 == Money.new(:c, 10)
  end

  def test_eql_when_different_Money_and_different_class
    refute @c100 == :c100
  end

  def test_minus_when_same_class
    assert_equal 900, @b1000 - @c100
  end

  def test_slush_when_same_class
    assert_equal 1100, @b1000 / @c100
  end

  def test_asterisk_when_same_class
    assert_equal 100000, @b1000 * @c100
  end

  def test_percent_when_same_class
    assert_equal 0, @b1000 % @c100
  end


end
