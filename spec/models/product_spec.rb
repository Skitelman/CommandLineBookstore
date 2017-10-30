require "spec_helper"

RSpec.describe Product do
  it "raises an error if created with an invalid price" do
    expect{
      Product.new(name: "Capital, Vol 1", price_cents: -2000)
    }.to raise_error(InvalidProductPriceCents, "Product price_cents must be an integer greater than 0.")
  end
  it "has a name and a price" do
    product = Product.new(name: "Capital, Vol 1", price_cents: 2000)
    expect(product.name).to eq("Capital, Vol 1")
    expect(product.price_cents).to eq(2000)
  end
  describe ".validate_product_id" do
    let(:product) { Product.new(name: "Capital, Vol 2", price_cents: 2500) }
    it "returns true if there is a product" do
      expect(described_class.validate_product_id(product.id)).to eq(true)
    end
    it "raises error if no product with id" do
      expect{
        described_class.validate_product_id(1000)
      }.to raise_error(InvalidProduct, "No product with id = #{1000}")
    end
  end
end
