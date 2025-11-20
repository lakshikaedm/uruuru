import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["postalCode", "prefecture", "city", "address1", "address2", "error"]
  static values = {
    url: String,
    errorMessage: String
  }

  connect() {
    console.log("postal-code-lookup: connected")
  }

  async lookup() {
    const raw = this.postalCodeTarget.value.replace(/[^\d]/g, "")
    console.log("postal-code-lookup: blur, value =", raw)

    if (raw.length < 7) {
      console.log("postal-code-lookup: not 7 digits, skipping")
      return
    }

    const baseUrl = this.urlValue || "/postal_code"
    const separator = baseUrl.includes("?") ? "&" : "?"
    const url = `${baseUrl}${separator}postal_code=${encodeURIComponent(raw)}`
    console.log("postal-code-lookup: fetching", url)

    this.setError("")

    try {
      const res = await fetch(url)
      const data = await res.json()

      console.log("postal-code-lookup: response", res.status, data)

      if (!res.ok) {
        this.setError(data.message || this.defaultErrorMessage())
        return
      }

      this.applyPrefecture(data)
      this.applyCity(data)
    } catch (e) {
      console.error("postal-code-lookup error:", e)
      this.setError(this.defaultErrorMessage())
    }
  }

  applyPrefecture(data) {
    if (!this.hasPrefectureTarget) return
    const { prefecture_ja, prefecture_en } = data
    const targetNames = [prefecture_ja, prefecture_en].filter(Boolean)

    const options = Array.from(this.prefectureTarget.options)
    const found = options.find((opt) => {
      const text = opt.textContent.trim()
      const value = (opt.value || "").trim()
      return targetNames.includes(text) || targetNames.includes(value)
    })

    if (found) {
      this.prefectureTarget.value = found.value
    }
  }

  applyCity(data) {
    if (!this.hasCityTarget) return
    if (this.cityTarget.value) return

    this.cityTarget.value = data.city || ""
  }

  defaultErrorMessage() {
    if (this.hasErrorMessageValue) return this.errorMessageValue
    return "住所を取得できませんでした。郵便番号をご確認ください。"
  }

  setError(message) {
    if (!this.hasErrorTarget) return
    this.errorTarget.textContent = message || ""
  }
}
