require "spec_helper"

RSpec.describe Order do
  after do
    LineItem.class_variable_set(:@@data_store, {})
    Product.class_variable_set(:@@data_store, {})
    Discount.class_variable_set(:@@data_store, {})
  end
  let(:product) { Product.new(name: "Capital, Vol 1", price_cents: 2000) }
  let(:line_item) { LineItem.new(product_id: product.id, quantity: 1) }
  it "has many line_items" do
    order = described_class.new([line_item])
    expect(order.line_items).to eq([line_item])
  end
  it "can have a discount" do
    discount = Discount.new(code: :WELCOME, percentage: 50, type: :all)
    order = described_class.new([line_item], :WELCOME)
    expect(order.discount_code).to eq(:WELCOME)
  end
  describe ".add_line_item" do
    it "adds new line_item to order" do
      order = described_class.new([])
      expect{ order.add_line_item(line_item)} .to change{ order.line_items }.from([]).to([line_item])
    end
    it "raises error if line_item is not valid" do
      order = described_class.new([])
      expect{ order.add_line_item("line_item")} .to raise_error(StandardError)
    end
  end
  describe ".clear_line_items" do
    it "removes all line_items from order" do
      order = described_class.new([line_item])
      expect{ order.clear_line_items} .to change{ order.line_items }.from([line_item]).to([])
    end
  end
  describe ".discount" do
    it "returns discount object corresponding to discount code" do
      discount = Discount.new(code: :WELCOME, percentage: 50, type: :all)
      order = Order.new([], discount.code)
      expect(order.discount).to eq(discount)
    end
    it "returns nil if there is no discount code" do
      order = Order.new([])
      expect(order.discount).to eq(nil)
    end
  end
end
