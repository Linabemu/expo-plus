import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="wishes"
export default class extends Controller {
  static targets = ["hearts"]
  static values = {path: String}

  connect() {
    // console.log(this.element)
    // console.log(this.heartsTarget)
    //  console.log("TODO: like request in AJAX")
    this.csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content")
  }


  like(event) {
    event.preventDefault()

    fetch(this.pathValue, {
      method: "POST",
      headers: { "Accept": "application/json", "X-CSRF-Token": this.csrfToken },
      // body: new FormData(this.heartsTarget)
    })
      .then(response => response.json())
      .then((data) => {
        this.heartsTarget.insertAdjacentHTML("afterend", data.heart);
        this.heartsTarget.remove();
      })
  }

}
