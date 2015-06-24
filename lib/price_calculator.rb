class PriceCalculator
  attr_accessor :rules, :price, :quantity

  def initialize(rules_list, price, quantity)
    @rules = rules_list
    @price = price
    @quantity = quantity
  end

  def calculate
    price * quantity
  end

  def apply_discounts
#    get_free_ones
#    apply_discounts
  end

end
