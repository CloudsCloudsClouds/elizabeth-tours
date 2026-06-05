import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide"]
  static values = { index: Number }

  connect() {
    this.start()
  }

  disconnect() {
    this.stop()
  }

  start() {
    this.interval = setInterval(() => this.next(), 5000)
  }

  stop() {
    if (this.interval) {
      clearInterval(this.interval)
      this.interval = null
    }
  }

  pause() {
    this.stop()
  }

  resume() {
    this.start()
  }

  next(event) {
    if (event) event.preventDefault()
    let i = this.indexValue + 1
    if (i >= this.slideTargets.length) i = 0
    this.go(i)
  }

  previous(event) {
    if (event) event.preventDefault()
    let i = this.indexValue - 1
    if (i < 0) i = this.slideTargets.length - 1
    this.go(i)
  }

  go(index) {
    this.indexValue = index
    this.slideTargets[index].scrollIntoView({ behavior: "smooth", block: "nearest", inline: "start" })
  }
}
