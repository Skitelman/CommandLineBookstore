require "spec_helper"

RSpec.describe LineItem do
  after do
    LineItem.class_variable_set(:@@data_store, {})
    Product.class_variable_set(:@@data_store, {})
  end
  it "validates product_id" do
    expect{
      described_class.new(product_id: 1, quantity: 1)
    }.to raise_error(InvalidProduct, "No product with id = 1")
  end
  it "validates quantity" do
    product = Product.new(name: "Capital, Vol 1", price_cents: 2000)
    expect{
      described_class.new(product_id: 1, quantity: 0)
    }.to raise_error(InvalidLineItemQuantity, "LineItem quanity must be an integer greater than 0.")
  end
  it "creates line item with valid product_id and quantity" do
    product = Product.new(name: "Capital, Vol 1", price_cents: 2000)
    line_item = described_class.new(product_id: product.id, quantity: 1)
    expect(line_item.product_id).to eq(product.id)
    expect(line_item.quantity).to eq(1)
  end
  describe ".product" do
    it "returns the product object corresponding to the product_id" do
      product = Product.new(name: "Capital, Vol 1", price_cents: 2000)
      line_item = described_class.new(product_id: product.id, quantity: 2)
      expect(line_item.product).to eq(product)
    end
  end
  describe ".total_in_cents" do
    it "calculates total cost in cents for the line item" do
      product = Product.new(name: "Capital, Vol 1", price_cents: 2000)
      line_item = described_class.new(product_id: product.id, quantity: 2)
      expect(line_item.total_in_cents).to eq(4000)
    end
  end
end
