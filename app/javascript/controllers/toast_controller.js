import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Auto-dismiss after 5 seconds
    setTimeout(() => {
      this.dismiss()
    }, 3000)
  }

  dismiss() {
    // Add fade-out animation
    this.element.classList.add('animate-fade-out-down')
    
    // Remove element after animation completes
    setTimeout(() => {
      this.element.remove()
    }, 400) // Match animation duration
  }
}

