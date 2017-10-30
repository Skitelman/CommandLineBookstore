require "./config/environment"

class LineItemProcessor
  attr_reader :line_item, :discount

  def initialize(line_item, discount = nil)
    @line_item = line_item
    @discount = discount
  end

  ##
  # Boolean method that determines if there is a dicount applicable to the line item.
  # Returns true if the line_item can be discounted.
  # Returns false otherwise.
  #
  def has_discount?
    !discount.nil? && (!discount.product_list? || discount.product_ids.include?(line_item.product_id))
  end

  ##
  # Returns that amount that is discounted from the line item.
  # Returns 0 if there is no applicable discount.
  #
  def discount_amount
    has_discount? ? (line_item.total_in_cents * discount.percentage/100.0).to_i : 0
  end

  ##
  # Returns that total amount that will be charged for the line item taking into account
  # any applicable discount.
  #
  def discounted_total
    line_item.total_in_cents - discount_amount
  end
end
