class Money
  attr_reader :value, :material

  def initialize(material, value)
    @material = material
    @value = value
  end

  def inspect
    "Money.#{material}#{value}"
  end

  def to_s
    "Money.#{material}#{value}"
  end

  def hash
    to_s.hash
  end

  def eql?(other)
    other.instance_of?(Money) && value.eql?(other.value) && to_s.eql?(other.to_s)
  end

  def ==(other)
    other.is_a?(Money) && value == other.value
  end

  def +(other)
    self.value + other.value if other.is_a?(Money)
  end

  def -(other)
    value - other.value if other.is_a?(Money)
  end

  def *(other)
    value * other.value if other.is_a?(Money)
  end

  def /(other)
    value / other.value if other.is_a?(Money)
  end

  def %(other)
    value % other.value if other.is_a?(Money)
  end

  def self.produce_money(material, value)
    method = "#{material}#{value}"
    define_method(method) do |material, value|
      self.new(material, value)
    end
  end
end
