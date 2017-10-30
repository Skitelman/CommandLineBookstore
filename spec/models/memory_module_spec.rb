require "spec_helper"

RSpec.describe MemoryModule do
  class Klass
    include MemoryModule
    attr_reader :id
    def initialize
      add_to_database
    end
    private
    def self.data_store
      @@data_store ||= {}
    end
  end
  describe ".all" do
    it "returns all instances of the model" do
      model_1 = Klass.new
      model_2 = Klass.new
      expect(Klass.all).to include(model_1, model_2)
    end
  end
  describe ".find" do
    it "finds a model by id" do
      model_1 = Klass.new
      model_2 = Klass.new
      expect(Klass.find(model_2.id)).to eq(model_2)
    end
  end
end
