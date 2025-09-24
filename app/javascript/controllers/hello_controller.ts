import { Controller } from "@hotwired/stimulus";

export default class HelloController extends Controller {
  connect(): void {
    if (this.element instanceof HTMLElement) {
      this.element.textContent = "Hello World!";
    }
  }
}
