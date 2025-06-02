# db/seeds.rb

# --- FRASES MOTIVACIONALES ---
puts "Limpiando frases motivacionales previas..."
MotivationalPhrase.destroy_all # DESCOMENTADO para borrar antes de crear
puts "Creando frases motivacionales..."
MotivationalPhrase.create!([
  { content: "Cree en ti." },
  { content: "Hoy es el día." },
  { content: "Sigue adelante." }
])
puts "¡Frases motivacionales creadas!"
puts "Total de frases: #{MotivationalPhrase.count}"

# --- PRODUCTOS ---
puts "\nLimpiando productos previos..." # \n para una nueva línea en la salida
Product.destroy_all # DESCOMENTADO para borrar antes de crear
puts "Creando productos..."
Product.create!([
  { name: "Taza", description: "Perfecta taza para tus bebidas calientes, personalizable con tu frase favorita.", price: 10.0, image_url: "taza.jpg" },
  { name: "Camiseta", description: "Cómoda camiseta de algodón, ideal para llevar tu inspiración a todas partes.", price: 10.0, image_url: "camiseta.jpg" },
  { name: "Hoodie", description: "Cálido y moderno hoodie, personalízalo y destaca.", price: 10.0, image_url: "hoodie.jpg" },
  { name: "Medias", description: "Medias únicas y divertidas para empezar el día con buen pie.", price: 10.0, image_url: "medias.jpg" },
  { name: "Gorra", description: "Gorra con estilo para protegerte del sol y lucir tu frase.", price: 10.0, image_url: "gorra.jpg" },
  { name: "Agenda", description: "Organiza tus días con esta agenda inspiradora.", price: 10.0, image_url: "agenda.jpg" },
  { name: "Bolso", description: "Práctico bolso de tela, perfecto para tus compras o el día a día.", price: 10.0, image_url: "bolso.jpg" },
  { name: "Termo", description: "Mantén tus bebidas a la temperatura ideal con este termo personalizado.", price: 10.0, image_url: "termo.jpg" },
  { name: "Maceta", description: "Dale un toque verde y motivador a tu espacio con esta maceta.", price: 10.0, image_url: "maceta.jpg" },
  { name: "Mochila", description: "Lleva todo lo que necesitas en esta mochila resistente y con mensaje.", price: 10.0, image_url: "mochila.jpg" }
])
puts "¡Productos creados!"
puts "Total de productos: #{Product.count}"

# --- USUARIO ADMINISTRADOR ---
puts "\nCreando o verificando usuario administrador..." # \n para una nueva línea
admin_email = "admin@10dencias.com"
admin_password = "password123" # ¡CAMBIA ESTA CONTRASEÑA por una segura en producción!

admin_user = User.find_or_create_by!(email: admin_email) do |user|
  user.password = admin_password
  user.password_confirmation = admin_password
  user.is_admin = true
  puts "Nuevo usuario administrador #{admin_email} creado."
end

# Asegurar que sea admin si ya existía y no lo era
if admin_user.persisted? && !admin_user.is_admin?
  admin_user.update!(is_admin: true)
  puts "Usuario existente #{admin_email} actualizado a administrador."
elsif admin_user.persisted? && admin_user.is_admin? && admin_user.email == admin_email # Solo si es el admin que estamos buscando
  puts "Usuario administrador #{admin_email} ya existe y está configurado."
end

# Opcional: Actualizar contraseña si es necesario (si la cambias en este archivo)
# if admin_user.persisted? && !admin_user.authenticate(admin_password)
#   puts "Actualizando contraseña para #{admin_email}..."
#   admin_user.password = admin_password
#   admin_user.password_confirmation = admin_password
#   admin_user.save!
# end

puts "Total de usuarios: #{User.count}"
puts "Total de administradores: #{User.where(is_admin: true).count}"

# ... (código existente para frases, productos y admin user) ...

# --- DATOS GEOGRÁFICOS ---
puts "\nLimpiando datos geográficos previos (ciudades, provincias, países de ejemplo)..."
# Es importante el orden de destroy_all por las dependencias de foreign key
# y las asociaciones dependent: :destroy que hemos configurado.
# Si Country tiene dependent: :destroy en has_many :provinces, y Province tiene en has_many :cities,
# destruir Country debería destruir sus Provinces y Cities.
# Sin embargo, para ser explícitos y controlar el proceso:
City.destroy_all
Province.destroy_all
Country.destroy_all

puts "Creando datos geográficos..."

# País
ecuador = Country.create!(name: "Ecuador")
puts "País creado: #{ecuador.name}"

# Provincias de Ecuador
pichincha = ecuador.provinces.create!(name: "Pichincha")
guayas = ecuador.provinces.create!(name: "Guayas")
puts "Provincias creadas para #{ecuador.name}: #{pichincha.name}, #{guayas.name}"

# Ciudades de Pichincha
quito = pichincha.cities.create!(name: "Quito")
sangolqui = pichincha.cities.create!(name: "Sangolquí") # Corregido el acento si es necesario
puts "Ciudades creadas para #{pichincha.name}: #{quito.name}, #{sangolqui.name}"

# Ciudades de Guayas
guayaquil = guayas.cities.create!(name: "Guayaquil")
duran = guayas.cities.create!(name: "Durán") # Corregido el acento si es necesario
puts "Ciudades creadas para #{guayas.name}: #{guayaquil.name}, #{duran.name}"


puts "\n--- Resumen de Datos Geográficos ---"
puts "Total de Países: #{Country.count}"
puts "Total de Provincias: #{Province.count}"
puts "Total de Ciudades: #{City.count}"

# Para verificar las asociaciones:
if ecuador.provinces.count == 2 && pichincha.cities.count == 2 && guayas.cities.count == 2
  puts "Asociaciones geográficas verificadas correctamente."
else
  puts "Error en la verificación de asociaciones geográficas."
end