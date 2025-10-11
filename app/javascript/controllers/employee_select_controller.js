import { Controller } from "@hotwired/stimulus"

export default class extends Controller { //this is
  static targets = ["card", "hiddenField", "employeeDisplay", "placeholder", "formFields"]

  selectEmployee(event) {
    const clickedCard = event.currentTarget
    const employeeId = clickedCard.dataset.employeeId
    const employeeName = clickedCard.dataset.employeeName
    const employeeEmail = clickedCard.dataset.employeeEmail

    // Remove selection from all cards - find the actual card div inside
    this.cardTargets.forEach(wrapper => {
      const card = wrapper.querySelector('.flex.items-center')
      if (card) {
        card.classList.remove('border-green-950', 'bg-green-50/80', 'backdrop-blur-sm')
        card.classList.add('border-gray-200', 'bg-white')
      }
    })

    // Select clicked card - find the actual card div inside
    const selectedCard = clickedCard.querySelector('.flex.items-center')
    if (selectedCard) {
      selectedCard.classList.remove('border-gray-200', 'bg-white')
      selectedCard.classList.add('border-green-950', 'bg-green-50/80', 'backdrop-blur-sm')
    }

    // Update hidden field
    this.hiddenFieldTarget.value = employeeId
    
    // Get initials from name
    const nameParts = employeeName.split(' ')
    const initials = nameParts.length >= 2 
      ? (nameParts[0][0] + nameParts[nameParts.length - 1][0]).toUpperCase()
      : employeeName.substring(0, 2).toUpperCase()
    
    // Update employee display with card component
    this.employeeDisplayTarget.innerHTML = `
      <div class="flex items-center p-4 bg-green-50/80 backdrop-blur-sm rounded-lg border-2 border-green-950">
        <!-- Circle with initials -->
        <div class="flex-shrink-0 w-12 h-12 bg-green-900 text-white rounded-full flex items-center justify-center font-semibold text-sm">
          ${initials}
        </div>
        
        <!-- Name and Email -->
        <div class="ml-4 flex-1 min-w-0">
          <p class="text-sm font-medium text-gray-900 truncate">
            ${employeeName}
          </p>
          <p class="text-sm text-gray-500 truncate">
            ${employeeEmail}
          </p>
        </div>
      </div>
    `
    
    // Hide placeholder and show form fields (preserve flex classes on placeholder)
    this.placeholderTarget.style.display = 'none'
    this.formFieldsTarget.style.display = ''
  }
}

