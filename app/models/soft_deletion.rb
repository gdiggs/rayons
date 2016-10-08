module SoftDeletion
  def self.included(base)
    base.class_eval do
      default_scope { where(deleted: false) }
    end
  end

  def destroy
    update_attribute(:deleted, true)
  end
end
