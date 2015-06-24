class PriceCalculator
  attr_accessor :rules, :price, :quantity

  def initialize(rules_list, price, quantity)
    @rules = rules_list
    @price = price
    @quantity = quantity
  end

  def calculate
    chargeable_quantity = apply_free_products_policy
    product_price = apply_discount_product_policy

    (product_price * chargeable_quantity).round(2)
  end

  def apply_free_products_policy
    return quantity unless free_rule_exists?
    deduct = (quantity / free_rule.quantity).floor * free_rule.free
    quantity - deduct
  end

  def apply_discount_product_policy
    return price unless discount_rule_exists?
    if quantity >= discount_rule.quantity
      (price*(100-discount_rule.discount)/100)
    else
      price
    end
  end

  private

  def free_rule_exists?
    free_rule
  end

  def discount_rule_exists?
    discount_rule
  end

  def free_rule
    @free_rule ||= rules.free.first
  end

  def discount_rule
    @discount_rule ||= rules.discounts.first
  end

end
