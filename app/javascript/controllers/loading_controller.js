import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.minimumDisplayTime = 300 // Minimum time to show spinner (in ms)
    this.spinnerShownAt = null
    
    // Listen for Turbo navigation events
    document.addEventListener('turbo:before-visit', this.showSpinner.bind(this))
    document.addEventListener('turbo:load', this.hideSpinner.bind(this))
    document.addEventListener('turbo:render', this.hideSpinner.bind(this))
  }

  disconnect() {
    document.removeEventListener('turbo:before-visit', this.showSpinner.bind(this))
    document.removeEventListener('turbo:load', this.hideSpinner.bind(this))
    document.removeEventListener('turbo:render', this.hideSpinner.bind(this))
  }

  showSpinner() {
    const spinner = document.getElementById('loading-spinner')
    if (spinner) {
      this.spinnerShownAt = Date.now()
      spinner.classList.remove('hidden')
    }
  }

  hideSpinner() {
    const spinner = document.getElementById('loading-spinner')
    if (spinner && this.spinnerShownAt) {
      const elapsedTime = Date.now() - this.spinnerShownAt
      const remainingTime = Math.max(0, this.minimumDisplayTime - elapsedTime)
      
      setTimeout(() => {
        spinner.classList.add('hidden')
        this.spinnerShownAt = null
      }, remainingTime)
    }
  }
}

