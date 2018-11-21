Rails.configuration.git_revision = if File.exist? Rails.root.join("REVISION")
                                     File.read(Rails.root.join("REVISION")).strip
                                   elsif ENV["HEROKU_RELEASE_VERSION"]
                                     ENV["HEROKU_RELEASE_VERSION"]
                                   else
                                     `git rev-parse HEAD`.strip
                                   end

Rails.logger.info "Rayons running with revision #{Rails.configuration.git_revision}"
