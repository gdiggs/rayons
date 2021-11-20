class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  has_many :api_tokens
end
