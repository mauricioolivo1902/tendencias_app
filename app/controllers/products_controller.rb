# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  def index
    @products = Product.all.order(:name)
  end

  def show
    @product = Product.find(params[:id]) # Encuentra el producto por su ID
    @motivational_phrases = MotivationalPhrase.all # Obtiene todas las frases para el selector
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "El producto que buscas no fue encontrado."
    redirect_to products_path
  end
end