require "rspec"
require_relative "../lib/pricing_rules"

describe "Rules" do

  Product = Struct.new(:code)

  let(:product) { Product.new("XX")}
  let(:rules) do
    [{code: product.code, quantity: 2, free: 1},
     {code: product.code, quantity: 5, discount: 10},
     {code: "YY",         quantity: 3, discount: 30},
     {code: "ZZ",         quantity: 2, free: 1, discount:5}]
  end

  describe RulesFactory do

    let(:pricing_rules) { described_class.build(rules) }

    describe "RulesFactory creates a PricingRules class" do
      it { expect(pricing_rules.class).to eq(PricingRules) }
    end


    describe "with empty rules" do
      let(:rules) { [] }
      it { expect(pricing_rules.class).to eq(PricingRules) }
    end
  end


  describe PricingRules do

    context "with a collection of rules" do
      subject { RulesFactory.build(rules) }

      it { expect(subject).to respond_to(:rules) }
      it { expect(subject).to respond_to(:size) }
      it { expect(subject).to respond_to(:each) }
      it { expect(subject).to respond_to(:for) }

      it "responds to size as an Array" do
        expect(subject.size).to eq(4)
      end

      it "iterates rules as an array using 'each'" do
        counter = 0
        subject.each do |rule|
          counter +=1
        end
        expect(counter).to eq(subject.size)
      end

      describe "some magic SQL" do
        describe "get rules for an specific product" do
          it { expect(subject.for(product.code).size).to eql(2) }
          it { expect(subject.for(product.code).rules[0].code).to eql(product.code) }
        end
        describe "get rules that applies buy-one-get-one-free" do
          it { expect(subject.free.size).to eq(2) }
        end
        describe "get buy-one-get-one-free rules for an specific product" do
          it { expect(subject.free.for(product.code).size).to eq(1) }
        end
      end
    end

    context "with no rules" do
      let(:rules) { [] }
      subject { RulesFactory.build(rules) }

      it "responds to size as an Array" do
        expect(subject.size).to eq(0)
      end
    end

  end
end
