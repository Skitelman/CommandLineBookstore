require "spec_helper"

RSpec.describe LineItemProcessor do
  after do
    LineItem.class_variable_set(:@@data_store, {})
    Product.class_variable_set(:@@data_store, {})
    Discount.class_variable_set(:@@data_store, {})
  end
  let(:product_1) { Product.new(name: "Capital, Vol 1", price_cents: 2000) }
  let(:product_2) { Product.new(name: "Capital, Vol 2", price_cents: 2500) }
  let(:line_item_1) { LineItem.new(product_id: product_1.id, quantity: 2) }
  let(:line_item_2) { LineItem.new(product_id: product_2.id, quantity: 1) }
  let(:discount) { Discount.new(code: :WELCOME, percentage: 50, type: :all) }
  let(:pl_discount) { Discount.new(code: :VERSO, percentage: 25, type: :product_list, product_ids: [product_2.id]) }
  describe ".has_discount?" do
    it "returns true when discount type is all" do
      expect(described_class.new(line_item_1, discount).has_discount?).to eq(true)
      expect(described_class.new(line_item_2, discount).has_discount?).to eq(true)
    end
    it "returns true when line item references a product on the product list" do
      expect(described_class.new(line_item_1, pl_discount).has_discount?).to eq(false)
      expect(described_class.new(line_item_2, pl_discount).has_discount?).to eq(true)
    end
  end
  describe ".discount_amount" do
    it "returns amount being discounted from total" do
      expect(described_class.new(line_item_1, discount).discount_amount).to eq(2000)
      expect(described_class.new(line_item_2, pl_discount).discount_amount).to eq(625)
    end
    it "returns 0 if there is no discount" do
      expect(described_class.new(line_item_1, pl_discount).discount_amount).to eq(0)
    end
  end
  describe ".discounted_total" do
    it "returns total after discount" do
      expect(described_class.new(line_item_1, discount).discounted_total).to eq(2000)
      expect(described_class.new(line_item_2, pl_discount).discounted_total).to eq(1875)
    end
  end
end
