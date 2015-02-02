class Playlist < ActiveRecord::Base
  has_and_belongs_to_many :items

  default_scope { where(:deleted => false) }

  validates_presence_of :name

  def destroy
    self.deleted = true
    self.save!
  end

end
