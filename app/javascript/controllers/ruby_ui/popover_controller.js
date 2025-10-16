import { Controller } from "@hotwired/stimulus";
import {
  computePosition,
  flip,
  shift,
  offset,
  autoUpdate,
} from "@floating-ui/dom";

export default class extends Controller {
  static targets = ["trigger", "content"];
  static values = {
    open: { type: Boolean, default: false },
    options: { type: Object, default: {} },
    trigger: { type: String, default: "hover" },
  };

  connect() {
    this.closeTimeout = null;
    this.cleanup = null;
    this.addEventListeners();
  }

  disconnect() {
    this.removeEventListeners();
    if (this.cleanup) {
      this.cleanup();
    }
  }

  addEventListeners() {
    if (this.triggerValue === "hover") {
      this.triggerTarget.addEventListener("mouseenter", this.handleMouseEnter);
      this.triggerTarget.addEventListener("mouseleave", this.handleMouseLeave);
      this.contentTarget.addEventListener("mouseenter", this.handleMouseEnter);
      this.contentTarget.addEventListener("mouseleave", this.handleMouseLeave);
    } else if (this.triggerValue === "click") {
      this.triggerTarget.addEventListener("click", this.handleClick);
      document.addEventListener("click", this.handleOutsideClick);
    }
  }

  removeEventListeners() {
    this.triggerTarget.removeEventListener("mouseenter", this.handleMouseEnter);
    this.triggerTarget.removeEventListener("mouseleave", this.handleMouseLeave);
    this.contentTarget.removeEventListener("mouseenter", this.handleMouseEnter);
    this.contentTarget.removeEventListener("mouseleave", this.handleMouseLeave);
    this.triggerTarget.removeEventListener("click", this.handleClick);
    document.removeEventListener("click", this.handleOutsideClick);
  }

  handleMouseEnter = () => {
    clearTimeout(this.closeTimeout);
    this.openValue = true;
    this.showPopover();
  };

  handleMouseLeave = () => {
    this.closeTimeout = setTimeout(() => {
      this.openValue = false;
      this.hidePopover();
    }, 100);
  };

  handleClick = (event) => {
    event.stopPropagation();
    this.openValue = !this.openValue;
    if (this.openValue) {
      this.closeAllOtherPopovers();
      this.showPopover();
    } else {
      this.hidePopover();
    }
  };

  handleOutsideClick = (event) => {
    if (!this.element.contains(event.target) && this.openValue) {
      this.openValue = false;
      this.hidePopover();
    }
  };

  closeAllOtherPopovers() {
    // Find all other popover controllers and close them
    const allPopovers = document.querySelectorAll('[data-controller*="ruby-ui--popover"]');
    allPopovers.forEach((popoverElement) => {
      if (popoverElement !== this.element) {
        const controller = this.application.getControllerForElementAndIdentifier(
          popoverElement,
          "ruby-ui--popover"
        );
        if (controller && controller.openValue) {
          controller.openValue = false;
          controller.hidePopover();
        }
      }
    });
  }

  showPopover() {
    this.contentTarget.classList.remove("hidden");
    this.updatePosition();
  }

  hidePopover() {
    this.contentTarget.classList.add("hidden");
    if (this.cleanup) {
      this.cleanup();
    }
  }

  updatePosition() {
    if (this.cleanup) {
      this.cleanup();
    }

    this.cleanup = autoUpdate(this.triggerTarget, this.contentTarget, () => {
      computePosition(this.triggerTarget, this.contentTarget, {
        placement: this.optionsValue.placement || "bottom",
        middleware: [flip(), shift(), offset(8)],
      }).then(({ x, y }) => {
        Object.assign(this.contentTarget.style, {
          left: `${x}px`,
          top: `${y}px`,
        });
      });
    });
  }
}
