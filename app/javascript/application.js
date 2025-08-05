// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbo
//= require_tree .

import "@hotwired/turbo-rails"
import "controllers"
import "custom/menu"
import "bootstrap"
import locales from "custom/locales.json"
import I18n from "./i18n"

I18n.translations = locales
