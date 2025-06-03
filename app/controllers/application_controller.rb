# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Helper methods to be available in all controllers and views
  helper_method :current_user, :logged_in?, :admin?, :current_cart # Asegurarse de que current_cart también sea helper_method

  private

  def current_user
    # Busca el usuario en la base de datos usando el user_id almacenado en la sesión.
    # ||= solo asigna si @current_user es nil, para evitar consultas repetidas a la BD.
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    # Devuelve true si current_user existe (es decir, el usuario está logueado), false en caso contrario.
    !!current_user
  end

  def admin?
    # Devuelve true si el usuario está logueado y es administrador.
    # Rails automáticamente crea un método de pregunta (is_admin?) para columnas booleanas.
    logged_in? && current_user.is_admin?
  end

  def require_user
    # Redirige al login si el usuario no está logueado.
    unless logged_in?
      flash[:alert] = "Debes iniciar sesión para acceder a esta página."
      redirect_to login_path
    end
  end

  def require_admin
    # Redirige al login si el usuario no está logueado o no es admin.
    unless admin?
      flash[:alert] = "No tienes permiso para acceder a esta página."
      redirect_to logged_in? ? root_path : login_path
    end
  end

  def current_cart
    # Si ya tenemos el carrito en la instancia de la variable, lo retornamos.
    return @current_cart if defined?(@current_cart) && @current_cart.present?

    # Intenta encontrar el carrito por el ID de la sesión
    if session[:cart_id]
      @current_cart = Cart.find_by(id: session[:cart_id])
    end

    # Si no se encontró un carrito válido en la sesión, o si la sesión no tiene un cart_id,
    # crea un nuevo carrito y guárdalo en la sesión.
    if @current_cart.nil?
      @current_cart = Cart.create # Crea un nuevo carrito
      session[:cart_id] = @current_cart.id # Guarda el ID del nuevo carrito en la sesión
    end

    @current_cart # Retorna el carrito actual
  end
  # helper_method :current_cart # Esta línea ya estaba en la parte superior, solo para referencia.

end