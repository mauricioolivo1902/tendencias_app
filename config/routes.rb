# config/routes.rb
Rails.application.routes.draw do
  # Define la ruta raíz de la aplicación.
  root 'products#index'

  # Rutas para el panel de administración
  namespace :admin do
    root to: 'dashboard#index', as: 'dashboard'
    resources :motivational_phrases
  end

  # Rutas para la sesión de administrador (login/logout)
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  # Rutas públicas para productos (catálogo y detalle)
  resources :products, only: [:index, :show]

  # Rutas para los ítems del pedido (añadir, actualizar, eliminar del carrito)
  resources :order_items, only: [:create, :update, :destroy]

  # Rutas para el carrito (singular)
  resource :cart, only: [:show, :update, :destroy]

  # Rutas para el proceso de checkout (singular)
  resource :checkout, only: [:new, :create] # <--- AÑADIDA ESTA LÍNEA

  # Ruta de health check
  get "up" => "rails/health#show", as: :rails_health_check
end