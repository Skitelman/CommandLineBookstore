require "./config/environment"

class Discount
  include MemoryModule
  DISCOUNT_TYPES = [:all, :product_list].freeze
  attr_reader :id, :code, :percentage, :type, :product_ids

  def initialize(code:, percentage:, type:, product_ids: [])
    @code = code.to_sym
    @percentage = percentage.to_i
    @type = type.to_sym
    @product_ids = product_ids
    validate
    add_to_database
  end

  ##
  # Find's `Discount` saved in memory with given discount code.
  # If it finds a discount it returns the `Discount` object. Otherwise it returns `nil`.
  def self.find_by_code(code)
    self.all.find{ |discount| discount.code == code }
  end

  ##
  # Boolean method that indicates if a given discount is of the type `:product_list`.
  # It returns true if the discount has type `:product_list`, otherwise it returns false.
  def product_list?
    self.type == :product_list
  end

  private

  ##
  # Runs all discount validations. Returns true if discount is valid,
  # otherwise it raises the appropriate error.
  #
  def validate
    validate_code
    validate_percentage
    validate_type
    validate_product_ids if product_list?
    true
  end

  ##
  # Ensures that the discount has a unique code. If there is no discount in memory with
  # the same code it returns true. If there is a discount with the same code it raises
  # an `InvalidDiscountCode` error.
  #
  def validate_code
    if Discount.find_by_code(code).nil?
      true
    else
      raise(InvalidDiscountCode, "There is already a discount with code '#{code}'.")
    end
  end

  ##
  # Ensures that the discount percentage is between 0 and 100. Returns true if percentage
  # is in valid range, otherwise it raises an `InvalidDiscountPercentage` error.
  #
  def validate_percentage
    (0..100).include?(percentage) ? true : raise(InvalidDiscountPercentage)
  end

  ##
  # Ensures that the discount type is `:all` or `:product_list`. Returns true if type is valid,
  # otherwise it raises an `InvalidDiscountType` error.
  #
  def validate_type
    DISCOUNT_TYPES.include?(type) ? true : raise(InvalidDiscountType)
  end

  ##
  # Ensures that all product_ids in a product list correspond to actual products stored in memeory.
  # Returns true if all product_ids are valid, otherwise it raises an `InvalidProduct` error.
  #
  def validate_product_ids
    product_ids.each do |product_id|
      Product.validate_product_id(product_id)
    end
    true
  end

  def self.data_store
    @@data_store ||= {}
  end
end

class InvalidDiscountCode < StandardError
  def initialize(msg="There is already a discount with that code.")
    super
  end
end

class InvalidDiscountPercentage < StandardError
  def initialize(msg="Discount percentage must be an integer between 0 and 100.")
    super
  end
end

class InvalidDiscountType < StandardError
  def initialize(msg="The only valid types are 'all' and 'product_list'.")
    super
  end
end
