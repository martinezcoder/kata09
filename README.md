Prerequisits
* Ruby 2.0 or higher

To execute the tests run:
```
bundle exec rake
```


This code lets you add this kind of rules:

* If you buy more than X products A, you will get Y% discount.
* For each X products A that you bought, you will get Y free products B.
  A and B could or not be the same product.


**PricingRules** class has been refactored to work as an Array of
Rules. This has been done following the recommendations of Sandi
Metz's book.
