require "./config/environment"

class LineItem
  include MemoryModule
  attr_reader :id, :product_id, :quantity

  def initialize(product_id:, quantity:)
    @product_id = product_id.to_i
    @quantity = quantity.to_i
    validate
    add_to_database
  end

  ##
  # Returns the `Product` object corresponding to the `product_id`.
  #
  def product
    Product.find(product_id)
  end

  ##
  # Returns the total price for the line item.
  #
  def total_in_cents
    product.price_cents * quantity
  end

  ##
  # Validates line item. Returns true if line item is valid. If the product_id is invalid it
  # raises an `InvalidProduct` error. If the quantity is not a non-negative integer it
  # raises an `InvalidLineItemQuantity` error.
  def validate
    Product.validate_product_id(product_id)
    quantity <= 0 ? raise(InvalidLineItemQuantity) : true
  end

  private

  def self.data_store
    @@data_store ||= {}
  end
end

class InvalidLineItemQuantity < StandardError
  def initialize(msg="LineItem quanity must be an integer greater than 0.")
    super
  end
end
