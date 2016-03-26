if File.exist? Rails.root.join("REVISION")
  Rails.configuration.git_revision = File.read(Rails.root.join("REVISION")).strip
else
  Rails.configuration.git_revision = `git rev-parse HEAD`.strip
end

Rails.logger.info "Rayons running with revision #{Rails.configuration.git_revision}"
