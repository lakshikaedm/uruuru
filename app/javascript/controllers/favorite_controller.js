import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]

  connect() {
    this.isFavorited = false
    this.updateIcon()
  }

  toggle() {
    this.isFavorited = !this.isFavorited
    this.updateIcon()
    this.element.setAttribute("aria-pressed", this.isFavorited.toString())
  }

  updateIcon() {
    if (this.isFavorited) {
      this.iconTarget.classList.add("fill-red-500")
      this.iconTarget.classList.remove("fill-gray-400")
    } else {
      this.iconTarget.classList.add("fill-gray-400")
      this.iconTarget.classList.remove("fill-red-500")
    }
  }
}
