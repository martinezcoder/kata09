require "rspec"
require_relative "../lib/checkout"

describe "TextMaster proposed tests" do

  let(:tea)    { @items[0] }
  let(:apple)  { @items[1] }
  let(:coffee) { @items[2] }

  before do
    products = [{code: "FR1", name: "Fruit tea", price: 3.11},
                {code: "AP1", name: "Apple",     price: 5.00},
                {code: "CF1", name: "Coffee",    price: 11.23}]
    @items = []
    products.each do |product|
      @items << Item.new(product[:code], product[:name], product[:price])
    end
  end

  let(:rules) do
    [{code: tea.code, quantity: 2, free: 1},
     {code: apple.code, quantity: 3, discount: 10}]
  end
  let(:pricing_rules) { RulesFactory.build(rules) }


  subject { Checkout.new(pricing_rules) }

  describe "first proposed basket" do
    before do
      subject.scan(tea)
      subject.scan(apple)
      subject.scan(tea)
      subject.scan(coffee)
    end

    it { expect(subject.total).to eq(19.34) }
  end

  describe "second proposed basket" do
    before do
      subject.scan(tea)
      subject.scan(tea)
    end

    it { expect(subject.total).to eq(3.11) }
  end

  describe "third proposed basket" do
    before do
      subject.scan(apple)
      subject.scan(apple)
      subject.scan(tea)
      subject.scan(apple)
    end

    it { expect(subject.total).to eq(16.61) }

  end

end

