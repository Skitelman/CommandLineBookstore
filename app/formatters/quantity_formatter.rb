class QuantityFormatter
  ##
  # This method pluralizes the number of copies.
  # ```
  # QuantityFormatter.pluralize(1) => "1 copy"
  # QuantityFormatter.pluralize(2) => "2 copies"
  # ```
  #
  def self.pluralize(quantity)
    quantity == 1 ? "1 copy" : "#{quantity} copies"
  end
end
