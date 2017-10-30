require "config/environment"


black_jacobins = Product.new(name: "Black Jacobins", price_cents: 20_00)
Product.new(name: "Freedom Is a Constant Struggle", price_cents: 15_00)

Discount.new(code: :WELCOME, percentage: 50, type: :all)
Discount.new(code: :JAC75, percentage: 75, type: :product_list, product_ids: [black_jacobins.id])
