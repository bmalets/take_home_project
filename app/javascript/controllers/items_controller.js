import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    toggle(event) {
        let checkbox = event.target
        let label = document.querySelector('label[for="' + checkbox.id + '"]')

        let requestUrl = this.data.get("update-url")
        let requestBody = {item: {dispute: checkbox.checked}}

        let csrfToken = document.head.querySelector(`meta[name="csrf-token"]`).getAttribute("content")

        fetch(requestUrl, {
            body: JSON.stringify(requestBody),
            method: 'PATCH',
            credentials: "include",
            headers: {
                "X-CSRF-Token": csrfToken,
                'Content-type': 'application/json; charset=UTF-8',
            },
        }).then((response) => {
            if (response.ok) {
                return response.json()
            } else {
                let invalidValue = checkbox.checked
                checkbox.checked = !invalidValue

                checkbox.blur()
            }
          })
          .then((data) => {
              label.textContent = data.item.next_status
          })
    }
}
