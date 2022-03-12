class Drink
  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end

  def inspect
    name
  end

  def to_s
    name.to_s
  end

  def hash
    name.hash
  end

  def eql?(other)
    other.instance_of?(Drink) && name.eql?(other.name)
  end

  def ==(other)
    other.is_a?(Drink) && name == other.name
  end
end
