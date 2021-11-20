require "securerandom"

class ApiToken < ApplicationRecord

  before_validation :generate_token, on: :create
  validates_presence_of :name, :token, :user_id
  validates_uniqueness_of :token
  attr_readonly :token

  belongs_to :user

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64(ENV.fetch("API_TOKEN_SIZE").to_i)
  end
end
