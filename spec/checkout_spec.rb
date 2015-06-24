require "rspec"
require_relative "../lib/checkout"

describe "CheckOut" do

  let(:tea)    { @items[0] }
  let(:apple)  { @items[1] }
  let(:coffee) { @items[2] }

  before do
    products = [{code: "FR1", name: "Fruit tea", price: 3.11},
                {code: "AP1", name: "Apple",     price: 5.0},
                {code: "CF1", name: "Coffee",    price: 11.23}]
    @items = []
    products.each do |product|
      @items << Item.new(product[:code], product[:name], product[:price])
    end
  end

  context "with empty pricing rules" do
    subject { Checkout.new() }

    describe "when product list is empty" do
      it "price will be 0" do
        expect(subject.total).to eql(0)
      end
    end
    describe "having multiple products" do
      before :each do
        subject.scan(tea)
        subject.scan(apple)
        subject.scan(coffee)
      end
      it "total is the sum of prices" do
        expect(subject.total).to eql(19.34)
      end
    end
    describe "having three apples" do
      before :each do
        subject.scan(apple)
        subject.scan(apple)
        subject.scan(apple)
      end
      it "total is the sum of price for each apple" do
        expect(subject.total).to eql(apple.price*3)
      end
    end
  end

  context "with buy-one-get-one-free rule" do

    describe "having a rule that gets us an X free product for each Y products in the cart" do
      let(:rules) do
        [{code: apple.code, quantity: 5, free: 2}]
      end
      let(:pricing_rules) { RulesFactory.build(rules) }

      subject { Checkout.new(pricing_rules) }

      context "having less products than neccessary for apply the rule" do
        before :each do
          1.upto 4 do
            subject.scan(apple)
          end
        end

        it "doesnt get any free apple" do
          expect(subject.total).to eq(apple.price*4)
        end
      end

      context "having just the minimum products to get free ones" do
        before :each do
          1.upto 5 do
            subject.scan(apple)
          end
        end

        it "gets one free apple" do
          expect(subject.total).to eq(apple.price*3)
        end

      end

      context "having as many products to get many free ones" do
        before :each do
          1.upto 11 do
            subject.scan(apple)
          end
        end
        it "gets two free apple" do
          expect(subject.total).to eq(apple.price*7)
        end

      end
    end
  end

  context "with discount rates" do
    describe "having a discount rule" do
      let(:rules) do
        [{code: apple.code, quantity: 3, discount: 10}]
      end
      let(:pricing_rules) { RulesFactory.build(rules) }

      subject { Checkout.new(pricing_rules) }

      context "having less products than the necessary for the rule" do
        before :each do
          1.upto 2 do
            subject.scan(apple)
          end
        end

        it "doesnt get any free apple" do
          expect(subject.total).to eql(apple.price*2)
        end
      end

      context "having enough products to get a discount" do
        before :each do
          1.upto 3 do
            subject.scan(apple)
          end
        end

        it "gets a discount rate for apples" do
          expect(subject.total).to eq( apple.price*3*(100-pricing_rules.discounts.first.discount)/100 )
        end
      end
    end
  end

  context "having both discount rates and bye-one-get-one-free" do
    let(:rules) do
      [{code: apple.code, quantity: 5, free: 2},
       {code: apple.code, quantity: 3, discount: 2},
      ]
    end
    let(:pricing_rules) { RulesFactory.build(rules) }

    subject { Checkout.new(pricing_rules) }

    context "having just the products to get free ones" do
        before :each do
          1.upto 5 do
            subject.scan(apple)
          end
        end

        it "applies first the free one policy and then the discount rate" do
          expect(subject.total).to eq( apple.price*3*(100-pricing_rules.discounts.first.discount)/100 )
        end

      end



  end

end
