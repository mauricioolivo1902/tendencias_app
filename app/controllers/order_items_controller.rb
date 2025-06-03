# app/controllers/order_items_controller.rb
class OrderItemsController < ApplicationController
  # La acción create ya la tenemos implementada
  def create
    @cart = current_cart
    product = Product.find(params[:product_id])
    motivational_phrase = MotivationalPhrase.find_by(id: params[:motivational_phrase_id])

    quantity_to_add = params[:quantity].to_i
    quantity_to_add = 1 if quantity_to_add < 1

    if motivational_phrase.nil?
      flash[:alert] = "Por favor, selecciona una frase motivacional."
      redirect_to product_path(product)
      return
    end

    @order_item = @cart.order_items.find_by(product_id: product.id, motivational_phrase_id: motivational_phrase.id)

    if @order_item
      @order_item.quantity += quantity_to_add
    else
      @order_item = @cart.order_items.build(
        product: product,
        motivational_phrase: motivational_phrase,
        quantity: quantity_to_add,
        price_at_purchase: product.price
      )
    end

    if @order_item.save
      update_cart_total(@cart)
      flash[:notice] = "#{quantity_to_add} x #{product.name} (con frase \"#{motivational_phrase.content.truncate(30)}\") ha(n) sido añadido(s) a tu carrito."
      redirect_to products_path
    else
      error_messages = @order_item.errors.full_messages.join(", ")
      flash[:alert] = "Error al añadir: #{error_messages}".presence || "Hubo un error al añadir el producto al carrito."
      redirect_to product_path(product)
    end
  end

  # Nueva acción para actualizar un OrderItem existente en el carrito
  def update
    @cart = current_cart
    @order_item = @cart.order_items.find(params[:id]) # Encontrar el OrderItem por su ID

    new_quantity = params[:order_item][:quantity].to_i # Leer la nueva cantidad del formulario
    new_quantity = 1 if new_quantity < 1 # Asegurar que la cantidad sea al menos 1

    if new_quantity == 0 # Si la cantidad se establece a 0, lo tratamos como una eliminación
      @order_item.destroy
      flash[:notice] = "El producto '#{@order_item.product.name}' ha sido eliminado de tu carrito."
    elsif @order_item.update(quantity: new_quantity) # Si la cantidad es > 0, actualizamos
      flash[:notice] = "Cantidad de '#{@order_item.product.name}' actualizada a #{new_quantity} en tu carrito."
    else
      error_messages = @order_item.errors.full_messages.join(", ")
      flash[:alert] = "Error al actualizar: #{error_messages}".presence || "Hubo un error al actualizar el producto en el carrito."
    end

    update_cart_total(@cart) # Recalcular el total del carrito
    redirect_to cart_path # Redirigir de nuevo a la página del carrito
  end

  # Nueva acción para eliminar un OrderItem del carrito
  def destroy
    @cart = current_cart
    @order_item = @cart.order_items.find(params[:id]) # Encontrar el OrderItem por su ID

    if @order_item.destroy
      update_cart_total(@cart) # Recalcular el total del carrito
      flash[:notice] = "El producto '#{@order_item.product.name}' ha sido eliminado de tu carrito."
    else
      error_messages = @order_item.errors.full_messages.join(", ")
      flash[:alert] = "Error al eliminar: #{error_messages}".presence || "Hubo un error al eliminar el producto del carrito."
    end

    redirect_to cart_path # Redirigir de nuevo a la página del carrito
  end

  private

  def update_cart_total(cart)
    # Si el carrito está vacío, el total debe ser 0.
    # Esto es importante para evitar errores si no hay order_items.
    if cart.order_items.empty?
      cart.update(total_amount: 0)
    else
      cart.update(total_amount: cart.order_items.sum { |item| item.price_at_purchase * item.quantity })
    end
  end

  # Parámetros fuertes para order_items (opcional pero buena práctica si se necesitara más control)
  # def order_item_params
  #   params.require(:order_item).permit(:quantity)
  # end
end