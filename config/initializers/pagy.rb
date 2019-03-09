require "pagy/extras/bootstrap"

Pagy::VARS[:items] = 100
Pagy::VARS[:size] = [1, 20, 20, 1]
Pagy::I18n.load(locale: "en", filepath: "config/locales/pagy-en.yml")
