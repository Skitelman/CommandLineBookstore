require "spec_helper"

RSpec.describe LineItemFormatter do
  after do
    LineItem.class_variable_set(:@@data_store, {})
    Product.class_variable_set(:@@data_store, {})
    Discount.class_variable_set(:@@data_store, {})
  end
  let(:product) { Product.new(name: "Capital, Vol 1", price_cents: 2000) }
  let(:line_item) { LineItem.new(product_id: product.id, quantity: 1) }
  describe ".cart_line_without_order_discount" do
    it "formats line item with total price and quantity" do
      expect(
        described_class.cart_line_without_order_discount(LineItemProcessor.new(line_item))
      ).to eq("1 copy of \"Capital, Vol 1\" for $20.00\n")
    end
  end
  describe ".cart_line_with_order_discount" do
    let(:discount) { Discount.new(code: :VERSO, percentage: 50, type: :product_list, product_ids: [product.id]) }
    it "formats line item with discount and line item total" do
      expect(
        described_class.cart_line_with_order_discount(LineItemProcessor.new(line_item, discount), 4)
      ).to eq("$10.00 (Original Price $20.00) for 1 copy of \"Capital, Vol 1\"\n")
    end
  end
end
