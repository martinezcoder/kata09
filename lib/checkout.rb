Item = Struct.new(:code, :name, :price)

class Checkout

  attr_reader :cart

  def initialize(pricing_rules)
    @rules = pricing_rules
    @cart = Hash.new
  end

  def scan(item)
    increment_or_initialize(item)
  end

  def total
    cart.inject(0) do |total, (item, quantity)|
      total + item.price * quantity
    end
  end

  protected

  def increment_or_initialize(item)
    @cart[item] ||= 0
    @cart[item] += 1
  end
end
