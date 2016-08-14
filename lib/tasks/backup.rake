require "dropbox_backup"

namespace :backup do
  desc "This backs up the collection to Dropbox"
  task dropbox: :environment do
    DropboxBackup.new.backup
  end
end
