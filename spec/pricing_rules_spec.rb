require "rspec"
require_relative "../lib/pricing_rules"

describe "Rules" do

  Product = Struct.new(:code)

  let(:product) { Product.new("XX")}
  let(:rules) do
    [{code: product.code, quantity: 2, free: 1},
     {code: "YY",         quantity: 3, discount: 30},
     {code: "ZZ",         quantity: 2, free: 1, discount:5}]
  end

  describe RulesFactory do

    describe "RulesFactory creates a PricingRules class" do
      let(:pricing_rules) { described_class.build(rules) }

      it { expect(pricing_rules.class).to eq(PricingRules) }
    end
  end


  describe PricingRules do
    subject { RulesFactory.build(rules) }

    it { expect(subject).to respond_to(:size) }
    it { expect(subject).to respond_to(:each) }
    it { expect(subject).to respond_to(:for) }

    it "responds to size as an Array" do
      expect(subject.size).to eq(3)
    end

    it "iterates rules as an array using 'each'" do
      counter = 0
      subject.each do |rule|
        counter +=1
      end
      expect(counter).to eq(subject.size)
    end

    it { expect(subject.for(product.code).size).to eql(1) }
    it { expect(subject.for(product.code)[0].class).to eql(OpenStruct) }
    it { expect(subject.for(product.code)[0].code).to eql(product.code) }

  end
end
