import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select";
import { get } from '@rails/request.js'

export default class extends Controller {

  static values = { url: String }

  connect() {
    this.element.setAttribute( "autocomplete", "random" );

    var config = {
      plugins: ['clear_button'],
      render: {
        option: this.render_option,
        item: this.render_option
      },
      valueField: 'value',
      loadThrottle: 400,
      load: (q, callback) => this.search(q, callback)
    }

    new TomSelect(this.element, config)
  }

  async search(q, callback) {
    const response = await get(this.urlValue, {
      query: { q: q },
      responseKind: 'json'
    })

    if(response.ok) {
      callback(await response.json)
    } else {
      callback()
    }
  }

  render_option(data, escape) {
    if(data.sub)
      return `
      <div>
        <div class="text">${escape(data.text)}</div>
        <div class="sub">${escape(data.sub)}</div>
      </div>`
    else
      return `<div>${escape(data.text)}</div>`
  }
}
