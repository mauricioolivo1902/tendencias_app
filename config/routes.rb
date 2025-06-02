# config/routes.rb
Rails.application.routes.draw do
  # Define la ruta raíz de la aplicación.
  # AHORA APUNTA AL CATÁLOGO DE PRODUCTOS.
  root 'products#index'

  # Rutas para el panel de administración
  namespace :admin do
    root to: 'dashboard#index', as: 'dashboard' # Ruta raíz del panel de admin: /admin
    resources :motivational_phrases           # CRUD para frases motivacionales en admin
  end

  # Rutas para la sesión de administrador (login/logout)
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  # Rutas públicas para productos (catálogo y detalle)
  # GET /products -> products#index (para listar todos los productos)
  # GET /products/:id -> products#show (para ver un producto específico)
  resources :products, only: [:index, :show]

  # Ruta de bienvenida (opcional, si 'products#index' es tu raíz, quizás no la necesites tanto)
  # Si la necesitas para otras cosas, asegúrate de tener un PagesController con acción home.
  # get 'welcome', to: 'pages#home', as: 'welcome_page'

  # Define que la aplicación puede responder a solicitudes de health check
  # Devuelve 200 si la app está funcionando, de lo contrario un error.
  # Útil para sistemas de monitoreo y balanceadores de carga.
  get "up" => "rails/health#show", as: :rails_health_check
end