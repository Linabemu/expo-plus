import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]
  connect(){
    console.log("description-display connected")
  }

  revealContent() {
    this.contentTarget.classList.toggle("d-none")
  }
}
