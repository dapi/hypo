# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/channels", under: "channels"
pin_all_from "app/javascript/elements", under: "elements"
pin_all_from "app/javascript/helpers", under: "helpers"
pin "bootstrap", to: "bootstrap.bundle.js"
pin "@rails/actioncable", to: "actioncable.esm.js"
