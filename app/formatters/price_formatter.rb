class PriceFormatter
  ##
  # This method creates a string with the price_in_cents formatted in dollars and cents.
  #
  # ```
  # PriceFormatter.price_in_dollars(1234) => "$12.34"
  # ```
  #
  def self.price_in_dollars(price_in_cents)
    sprintf("$%d.%02d", price_in_cents/100, price_in_cents % 100)
  end
end
