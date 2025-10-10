import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  showConfirmation(event) {
    event.preventDefault()
    event.stopPropagation()
    
    // Get the employee ID from the row
    const employeeId = this.element.dataset.employeeId
    
    // Find the confirmation row (next sibling)
    const confirmationRow = document.querySelector(`.confirmation-row[data-employee-id="${employeeId}"]`)
    
    if (confirmationRow) {
      confirmationRow.classList.remove('hidden')
    }
  }

  cancel(event) {
    event.preventDefault()
    event.stopPropagation()
    
    // Hide the confirmation row
    this.element.closest('tr').classList.add('hidden')
  }

  confirm(event) {
    event.stopPropagation()
    // Form will submit naturally
  }
}

