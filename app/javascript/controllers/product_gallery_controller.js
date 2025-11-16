import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["main", "thumb"]

  connect() {
    if (this.thumbTargets.length > 0) {
      this.setActive(this.thumbTargets[0])
    }
  }

  switch(event) {
    const thumb = event.currentTarget
    const full = thumb.dataset.full
    if (!full) return

    this.mainTarget.src = full

    this.setActive(thumb)
  }

  setActive(selectedThumb) {
    this.thumbTargets.forEach(t =>
      t.classList.remove("ring-2", "ring-orange-500")
    )

    selectedThumb.classList.add("ring-2", "ring-orange-500")
  }
}
