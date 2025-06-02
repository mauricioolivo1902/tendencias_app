class ApplicationController < ActionController::Base
  # Helper methods to be available in all controllers and views
  helper_method :current_user, :logged_in?, :admin?

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
      redirect_to logged_in? ? root_path : login_path # Si está logueado pero no es admin, a root. Sino a login.
                                                       # O siempre a login_path si se prefiere.
    end
  end
end