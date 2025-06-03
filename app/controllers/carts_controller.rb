# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  def show
    @cart = current_cart 
  end
end