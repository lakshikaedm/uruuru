import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]

  connect() {
    this.isFavorited = this.iconTarget.classList.contains("fill-red-500")
  }

  toggle() {
    this.isFavorited = !this.isFavorited
    this.updateIcon()
  }

  updateIcon() {
    this.iconTarget.classList.toggle("fill-red-500", this.isFavorited)
    this.iconTarget.classList.toggle("fill-gray-300", !this.isFavorited)
  }
}
