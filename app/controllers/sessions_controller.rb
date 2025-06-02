# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def new
    # ...
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.is_admin?
        session[:user_id] = user.id
        flash[:notice] = "¡Bienvenido Administrador!"
        redirect_to admin_dashboard_path # Asegúrate que esta línea esté así
      else
        flash.now[:alert] = "Acceso denegado. No eres un administrador."
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Correo electrónico o contraseña incorrectos."
      render :new, status: :unprocessable_entity
    end
  end

    def destroy
    session[:user_id] = nil # Elimina el user_id de la sesión
    flash[:notice] = "Has cerrado sesión correctamente."
    redirect_to login_path    # Redirige a la página de login
  end
end