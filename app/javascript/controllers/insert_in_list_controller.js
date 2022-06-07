import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="insert-in-list"
export default class extends Controller {
  static targets = ["items", "form"]
  static values = { position: String }

  connect() {
    console.log('hello')
    console.log(this.items)
    console.log(this.form)
    this.csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content")
  }

  send(event) {
    event.preventDefault()
    fetch(this.formTarget.action, {
      method: "POST",
      headers: { "Accept": "application/json", "X-CSRF-Token": this.csrfToken },
      body: new FormData(this.formTarget)
    })
      .then(response => response.json())
      .then((data) => {
        console.log(data)
        if (data.inserted_item) {
          this.itemsTarget.insertAdjacentHTML(this.positionValue, `<div class="d-flex">${data.inserted_item}</div>`);
        }
        this.formTarget.outerHTML = data.form
      })
  }

}
