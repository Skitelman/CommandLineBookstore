require "spec_helper"

RSpec.describe Discount do
  after do
    Discount.class_variable_set(:@@data_store, {})
    Product.class_variable_set(:@@data_store, {})
  end
  let(:product) { Product.new(name: "Capital, Vol 2", price_cents: 2000) }
  it "validates uniqueness of discount codes" do
    described_class.new(code: :NEW, percentage: 50, type: :all)
    expect{
      described_class.new(code: :NEW, percentage: 50, type: :all)
    }.to raise_error(InvalidDiscountCode, "There is already a discount with code 'NEW'.")
  end
  it "validates percentage" do
    expect{
      described_class.new(code: :NEW, percentage: 110, type: :all)
    }.to raise_error(InvalidDiscountPercentage, "Discount percentage must be an integer between 0 and 100.")
  end
  it "validates type" do
    expect{
      described_class.new(code: :WELCOME, percentage: 50, type: :bad_type)
    }.to raise_error(InvalidDiscountType, "The only valid types are 'all' and 'product_list'.")
  end
  it "validates product_ids when present" do
    expect{
      described_class.new(code: :JAC75, percentage: 75, type: :product_list, product_ids: [product.id + 1])
    }.to raise_error(InvalidProduct, "No product with id = #{product.id + 1}")
  end
  it "creates line item with valid product_id and quantity" do
    discount = described_class.new(code: :VERSO, percentage: 50, type: :product_list, product_ids: [product.id])
    expect(discount.code).to eq(:VERSO)
    expect(discount.percentage).to eq(50)
    expect(discount.type).to eq(:product_list)
    expect(discount.product_ids).to eq([product.id])
  end

  describe ".find_by_code" do
    it "returns nil if there is no discount with the code" do
      expect(described_class.find_by_code(:WELCOME)).to eq(nil)
    end
    it "returns unique discount with the valid code" do
      discount = described_class.new(code: :WELCOME, percentage: 50, type: :all)
      expect(described_class.find_by_code(:WELCOME)).to eq(discount)
    end
  end

  describe ".product_list?" do
    it "returns true if and only if discout has type product_list" do
      discount = described_class.new(code: :WELCOME, percentage: 50, type: :all)
      pl_discount = described_class.new(code: :VERSO,
                                        percentage: 50,
                                        type: :product_list,
                                        product_ids: [product.id])
      expect(discount.product_list?).to eq(false)
      expect(pl_discount.product_list?).to eq(true)
    end
  end
end
