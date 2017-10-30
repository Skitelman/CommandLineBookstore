require "spec_helper"

RSpec.describe CartApplication do
  after do
    LineItem.class_variable_set(:@@data_store, {})
    Product.class_variable_set(:@@data_store, {})
    Discount.class_variable_set(:@@data_store, {})
  end
  let(:product) { Product.new(name: "Capital, Vol 1", price_cents: 2000) }
  let(:line_item) { LineItem.new(product_id: product.id, quantity: 1) }
  describe ".display_cart" do
    context "when there is no discount on the order" do
      it "properly displays cart" do
        cart = Order.new([line_item])
        line_item_string = "1 copy of \"Capital, Vol 1\" for $20.00\n"

        expect(LineItemFormatter).to receive(:cart_line_without_order_discount).and_return(line_item_string)
        expect(described_class.display_cart(cart)).to eq("Your cart:\n\n#{line_item_string}---\nTotal $20.00")
      end
    end
    context "when there is a discount on the order" do
      it "properly displays cart" do
        discount = Discount.new(code: :WELCOME, percentage: 25, type: :all)
        cart = Order.new([line_item], discount.code)
        line_item_string = "$15.00 (Original Price $20.00) for 1 copy of \"Capital, Vol 1\"\n"

        expect(LineItemFormatter).to receive(:cart_line_with_order_discount).and_return(line_item_string)
        expect(described_class.display_cart(cart)).to eq("Your cart:\n\n#{line_item_string}---\nTotal $15.00")
      end
    end
  end
  describe ".total_cost" do
    it "finds the correct total cost with discounts" do
      product_2 = Product.new(name: "Capital, Vol 2", price_cents: 2500)
      line_item_2 = LineItem.new(product_id: product_2.id, quantity: 2)
      discount = Discount.new(code: :WELCOME, percentage: 25, type: :all)
      cart = Order.new([line_item, line_item_2], discount.code)
      expect(described_class.total_cost(cart)).to eq(5250)
    end
  end
end
