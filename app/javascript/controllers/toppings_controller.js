import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["quantity"]

  connect() {
    this.initializeQuantities()
  }

  initializeQuantities() {
    this.quantityTargets.forEach(input => {
      if (input.value) {
        input.disabled = false
      }
    });
  }

  toggleQuantity(event) {
    let checkbox = event.target;
    let quantityInput = this.quantityTargets.find(input => input.dataset.toppingId === checkbox.value)

    if (checkbox.checked) {
      quantityInput.disabled = false
      if (!quantityInput.value) {
        quantityInput.value = 1
      }
    } else {
      quantityInput.disabled = true
      quantityInput.value = ""
    }
  }
}
