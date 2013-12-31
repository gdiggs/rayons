base = ENV['SECRET_TOKEN'] || ('x' * 30)
Rayons::Application.config.secret_key_base = base
