class Admin::DashboardController < ApplicationController
before_action :require_admin # <--- AÑADE ESTA LÍNEA  
  def index
  end
end
