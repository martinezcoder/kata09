require 'forwardable'
class PricingRules
  extend Forwardable
  def_delegators :@rules, :size, :each
  include Enumerable

  def initialize(rules)
    @rules = rules
  end

  def for(product_code)
    select { |rule| rule.code == product_code}
  end
end


require 'ostruct'
class RulesFactory
  def self.build(config, rules_class = PricingRules)
    rules_class.new(
      config.collect { |rule_config|
        create_rule(rule_config)
      })
  end

  def self.create_rule(rule_config)
    OpenStruct.new(
      code: rule_config[:code],
      quantity: rule_config[:quantity],
      free: rule_config.fetch(:free, 0),
      discount: rule_config.fetch(:discount, 0)
    )
  end
end

