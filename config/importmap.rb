pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/custom", under: "custom"
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.1.3-4/app/assets/javascripts/rails-ujs.esm.js"
