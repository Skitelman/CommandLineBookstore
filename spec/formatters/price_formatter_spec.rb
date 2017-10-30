require "spec_helper"

RSpec.describe PriceFormatter do
  describe ".price_in_dollars" do
    it "returns a string with correct price" do
      expect(described_class.price_in_dollars(100)).to eq("$1.00")
      expect(described_class.price_in_dollars(1000)).to eq("$10.00")
      expect(described_class.price_in_dollars(1099)).to eq("$10.99")
    end
  end
end
