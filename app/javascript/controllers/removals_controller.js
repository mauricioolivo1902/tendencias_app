// app/javascript/controllers/removals_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  remove() {
    this.element.remove()
  }

  removeParent() {
    this.element.parentElement.parentElement.remove() // Ajusta según la estructura del DOM del flash
  }
}