import { Application } from "@hotwired/stimulus"
import "bootstrap"
import "custom/menu"
import "custom/image_upload"
//= require jquery
//= require bootstrap-sprockets
//= require_tree .

const application = Application.start()

application.debug = false
window.Stimulus   = application

export { application }
