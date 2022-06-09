import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="insert-avatar-in-list"
export default class extends Controller {
  static targets = ["items", "form", "participantsCount"]
  static values = { position: String }

  connect() {
    console.log(this.participantsCountTarget);
    this.csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content")
  }

  send(event){
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
          this.itemsTarget.insertAdjacentHTML("beforeend", data.inserted_item)
        }
        this.participantsCountTarget.innerHTML = data.participants_count
        this.formTarget.outerHTML = data.form
      })

  }
}
