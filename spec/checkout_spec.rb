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
    subject { Checkout.new(nil) }

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
      it "total with be sum of prices" do
        expect(subject.total).to eql(19.34)
      end
    end
    describe "having three apples" do
      before :each do
        subject.scan(apple)
        subject.scan(apple)
        subject.scan(apple)
      end
      it "total with be sum of price for each apple" do
        expect(subject.total).to eql(apple.price*3)
      end
    end
  end
end
