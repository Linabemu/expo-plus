import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="proposal-subscription"
export default class extends Controller {
  static values = { proposalId: Number, currentUserId: Number }
  static targets = ["messages", "message"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ProposalChannel", id: this.proposalIdValue},
      { received: data => {
        console.log(data);
        this.#insertMessageAndScrollDown(data.message_html);
        if (data.author_id != this.currentUserIdValue) {
          this.messageTargets[this.messageTargets.length - 1].classList.remove('float-end');
          this.messageTargets[this.messageTargets.length - 1].classList.add('float-start');
        }
      }}
      )
      console.log(`Subscribe to the chatroom with the id ${this.proposalIdValue}.`)
  }

  #insertMessageAndScrollDown(data) {
    // console.log(data)
    // console.log(this.messagesTarget)
    this.messagesTarget.insertAdjacentHTML("beforeend", data)
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
  }

  resetForm(event) {
    event.target.reset()
  }

  disconnect() {
    console.log("Unsubscribed from the chatroom")
    this.channel.unsubscribe()
  }

}
