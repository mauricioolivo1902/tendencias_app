// tailwind.config.js
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/components/**/*.{erb,rb}' // Para ViewComponents si los usas
  ],
  theme: {
    extend: {}, // Aquí puedes extender el tema de Tailwind más adelante
  },
  plugins: [
    // Plugins comunes de Tailwind (pueden requerir instalación vía npm/yarn si no están ya)
    // Por ahora, los dejaremos comentados para asegurar que el build básico funcione.
    // Si los necesitas, los instalaremos después.
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/aspect-ratio'),
    // require('@tailwindcss/typography'),
  ],
}