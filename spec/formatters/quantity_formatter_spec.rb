require "spec_helper"

RSpec.describe QuantityFormatter do
  describe ".pluralize" do
    it "returns a string with the correct number of copies" do
      expect(described_class.pluralize(1)).to eq("1 copy")
      expect(described_class.pluralize(2)).to eq("2 copies")
    end
  end
end
