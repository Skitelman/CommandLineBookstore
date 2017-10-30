require "./config/environment"

class LineItemFormatter
  ##
  # Formats a single line item with no discount. Takes a `LineItemProcessor` as an argument.
  #
  # ```
  # cart_line_without_order_discount(line_item) => "1 copy of \"Capital, Vol 1\" for $20.00\n"
  # ```
  #
  def self.cart_line_without_order_discount(line_item_processor)
    sprintf("%s of \"%s\" for %s\n",
      QuantityFormatter.pluralize(line_item_processor.line_item.quantity),
      line_item_processor.line_item.product.name,
      PriceFormatter.price_in_dollars(line_item_processor.line_item.total_in_cents)
    )
  end

  ##
  # Formats a single line item with a discount. Takes a `LineItemProcessor` as an argument.
  #
  # ```
  # cart_line_with_order_discount(line_item) => "$10.00 (Original Price $20.00) for 1 copy of \"Capital, Vol 1\"\n"
  # ```
  #
  def self.cart_line_with_order_discount(line_item_processor, price_string_length)
    sprintf("%#{price_string_length+2}s %23s for %s of \"%s\"\n",
      PriceFormatter.price_in_dollars(line_item_processor.discounted_total),
      original_price(line_item_processor),
      QuantityFormatter.pluralize(line_item_processor.line_item.quantity),
      line_item_processor.line_item.product.name,
    )
  end

  private

  def self.original_price(line_item_processor)
    if line_item_processor.has_discount?
      "(Original Price #{PriceFormatter.price_in_dollars(line_item_processor.line_item.total_in_cents)})"
    else
      ""
    end
  end
end
