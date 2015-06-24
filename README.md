
To execute the tests run:
```
bundle install
bundle exec rake
```
* About discounts: The discounts are applied using percentages

**PricingRules** class has been refactored to work as an Array of Rules. A rule factory class has been done following the recommendations of Sandi Metz's book that tells about parts of a bicycle. This will make it possible to introduce features like CSV loader for rules.

**PriceCalculator** takes care about pricing calculation applying the rules. It priorizates buy-one-get-one-free against discounts. That means that it will apply discounts after counting how many should be charged from the cart.
Same kind of rules are not acumulative. It gets always the first one in the list of rules type.
