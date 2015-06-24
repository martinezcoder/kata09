require_relative 'pricing_rules'
require_relative 'price_calculator'

Item = Struct.new(:code, :name, :price)

class Checkout

  attr_reader :cart, :rules

  def initialize(pricing_rules = RulesFactory.build())
    @rules = pricing_rules
    @cart = Hash.new
  end

  def scan(item)
    add_to_cart(item)
  end

  def total
    cart.inject(0) do |total, (item, quantity)|
      total + price_for(item, quantity)
    end
  end

  def rules_for(item)
    rules.for(item.code)
  end

  protected

  def add_to_cart(item)
    @cart[item] ||= 0
    @cart[item] += 1
  end

  def price_for(item, quantity)
    product_rules = rules.for(item.code)
    PriceCalculator.new(product_rules, item.price, quantity).calculate
  end
end

