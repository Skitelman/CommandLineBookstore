class Order
  attr_accessor :discount_code

  def initialize(line_items, discount_code = nil)
    @line_items = []
    line_items.each { |line_item| add_line_item(line_item)  }
    @discount_code = discount_code
    validate
  end

  ##
  # Returns a frozen array containing all of the line_items in the order.
  #
  def line_items
    @line_items.dup.freeze
  end

  ##
  # Adds a line item to the order and vaidates that the line_item being added
  # is indeed a valid line item. If the line item is valid, this method returns
  # an array of the order's line items. Otherwise it raises the appropriate error.
  def add_line_item(line_item)
    raise(TypeError) unless line_item.is_a?(LineItem)
    @line_items << line_item if line_item.validate
  end

  ##
  # Removes all line items from the order.
  #
  def clear_line_items
    @line_items = []
  end

  ##
  # Returns the `Discount` object corresponding to the order's discount code. If there is no
  # discount it returns `nil`.
  #
  def discount
    Discount.find_by_code(discount_code)
  end

  private

  ##
  # Validates discount code. If there is a discount code and does not correspond to a valid discount, it raises
  # and `InvalidDiscountCode` error. Otherwise it returns true.
  def validate
    !discount_code.nil? && discount.nil? ? raise(InvalidDiscountCode, "There is no discount with that code") : true
  end
end
