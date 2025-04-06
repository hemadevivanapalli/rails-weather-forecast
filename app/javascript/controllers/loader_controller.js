import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loader"
export default class extends Controller {
  static targets = ["spinner"]

  connect() {
    this.hideSpinner()
  }

  showSpinner() {
    this.spinnerTarget.style.display = "block"
  }

  hideSpinner() {
    this.spinnerTarget.style.display = "none"
  }
}
