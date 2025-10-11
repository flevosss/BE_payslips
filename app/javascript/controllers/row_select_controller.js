import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row"]

  selectRow(event) {
    // Stop event propagation to prevent other click handlers
    event.stopPropagation()
    
    // Remove selected class from all rows
    document.querySelectorAll('.employee-row').forEach(row => {
      row.classList.remove('bg-green-50', 'border-l-4', 'border-green-950')
    })
    
    // Add selected class to clicked row
    this.element.classList.add('bg-green-50', 'border-l-4', 'border-green-950')
  }
}
