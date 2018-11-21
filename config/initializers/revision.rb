Rails.configuration.git_revision = if File.exist? Rails.root.join("REVISION")
                                     File.read(Rails.root.join("REVISION")).strip
                                   elsif ENV["HEROKU_SLUG_COMMIT"]
                                     ENV["HEROKU_SLUG_COMMIT"]
                                   else
                                     `git rev-parse HEAD`.strip
                                   end

Rails.logger.info "Rayons running with revision #{Rails.configuration.git_revision}"
