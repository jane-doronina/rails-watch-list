import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bs-modal"
export default class extends Controller {
  connect() {
    console.log("bs-modal active")
    this.modal = new bootstrap.Modal(this.element);
    this.modal.show();
  }

  disconnect() {
    this.modal.hide();
  }

  submitEnd(event) {
    this.modal.hide();
  }
}
