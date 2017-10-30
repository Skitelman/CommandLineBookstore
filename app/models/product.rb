require "./config/environment"

class Product
  include MemoryModule
  attr_reader :id, :name, :price_cents

  def initialize(name:, price_cents:)
    @name = name.to_s
    @price_cents = price_cents
    validate
    add_to_database
  end

  ##
  # This method validates that a given product_id references an existing product in memory.
  # If there is a product it returns true, otherwise it raises an `InvalidProduct` error.
  #
  def self.validate_product_id(product_id)
    Product.find(product_id).nil? ? raise(InvalidProduct, "No product with id = #{product_id}") : true
  end

  private

  ##
  # This method validates a product price. If the price is a non-negative integer it raises
  # an `InvalidProductPriceCents` error. Otherwise it returns true.
  def validate
    price_cents <= 0 ? raise(InvalidProductPriceCents) : true
  end

  def self.data_store
    @@data_store ||= {}
  end
end

class InvalidProductPriceCents < StandardError
  def initialize(msg="Product price_cents must be an integer greater than 0.")
    super
  end
end

class InvalidProduct < StandardError
  def initialize(msg="No product with id")
    super
  end
end
