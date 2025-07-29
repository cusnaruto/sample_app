import { Application } from "@hotwired/stimulus"
import "bootstrap"
//= require jquery
//= require bootstrap-sprockets
//= require_tree .

const application = Application.start()

application.debug = false
window.Stimulus   = application

export { application }
