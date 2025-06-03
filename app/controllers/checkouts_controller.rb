# app/controllers/checkouts_controller.rb
class CheckoutsController < ApplicationController
  before_action :set_cart # Asegurarse de que el carrito esté disponible

  def new
    # Si el carrito está vacío, no se puede proceder al checkout
    if @cart.order_items.empty?
      flash[:alert] = "Tu carrito está vacío. ¡Añade productos antes de proceder al checkout!"
      redirect_to products_path # O a cart_path, según prefieras
      return
    end

    # Prepara un nuevo BillingAddress para el formulario.
    # Si el usuario está logeado, podemos intentar precargar la dirección más reciente
    # o crear una nueva asociada a su ID.
    @billing_address = current_user&.billing_addresses&.last || BillingAddress.new(user: current_user)
  end

  def create
    # Asegúrate de que el carrito no esté vacío al momento de procesar el checkout
    if @cart.order_items.empty?
      flash[:alert] = "Tu carrito está vacío. No se puede completar el checkout."
      redirect_to products_path
      return
    end

    # Creamos o actualizamos la BillingAddress con los datos del formulario
    # Si el usuario está logeado y tiene una dirección existente, la actualizamos.
    # De lo contrario, creamos una nueva.
    if current_user && current_user.billing_addresses.any?
      @billing_address = current_user.billing_addresses.last # O buscar por ID si se permite seleccionar
      if @billing_address.update(billing_address_params)
        # Éxito en actualizar la dirección
      else
        # Fallo en la actualización de la dirección
        flash.now[:alert] = "Error al actualizar tu información de facturación: #{@billing_address.errors.full_messages.join(', ')}"
        render :new, status: :unprocessable_entity # Renderiza de nuevo el formulario con errores
        return
      end
    else
      @billing_address = BillingAddress.new(billing_address_params)
      @billing_address.user = current_user if current_user # Asocia al usuario si está logeado

      unless @billing_address.save
        flash.now[:alert] = "Error al guardar tu información de facturación: #{@billing_address.errors.full_messages.join(', ')}"
        render :new, status: :unprocessable_entity # Renderiza de nuevo el formulario con errores
        return
      end
    end

    # Generar un número de orden único (simple UUID por ahora)
    order_number = SecureRandom.uuid

    # Crear la SalesOrder
    @sales_order = SalesOrder.new(
      # Eliminada la referencia 'cart: @cart' ya que SalesOrder no pertenece directamente a Cart
      billing_address: @billing_address,
      total_amount: @cart.total_amount,
      status: 'pending', # Por defecto 'pending'
      order_number: order_number
    )

    if @sales_order.save
      # Mover los OrderItems del Cart a la SalesOrder
      @cart.order_items.each do |item|
        item.update(cart_id: nil, sales_order: @sales_order) # Desasociar del carrito, asociar a la orden de venta
      end

      # Vaciar el carrito y recalcular su total (que ahora debería ser 0)
      @cart.update(total_amount: 0) # Establecer el total a 0 directamente

      flash[:notice] = "¡Tu pedido (No. #{order_number.first(8)}) ha sido realizado con éxito! Te hemos enviado un correo de confirmación."
      redirect_to products_path # O a una página de confirmación de pedido
    else
      # Si hay un error al guardar la SalesOrder
      flash.now[:alert] = "Error al procesar tu pedido: #{@sales_order.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity # Renderiza de nuevo el formulario
    end
  end

  private

  def set_cart
    @cart = current_cart # Asumiendo que 'current_cart' es un método que te da el carrito de la sesión
  end

  def billing_address_params
    params.require(:billing_address).permit(
      :first_name, :last_name, :identification_number,
      :country, :province, :city, :address, :phone_number
    )
  end
end
