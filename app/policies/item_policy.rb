class ItemPolicy
  attr_reader :user, :item

  def initialize(user, item)
    @user = user || User.new
    @item = item
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    @user.admin?
  end
  [:create?, :edit?, :update?, :import?, :destroy?].each { |meth| alias_method meth, :new? }
end
