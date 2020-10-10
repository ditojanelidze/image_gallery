class User < ApplicationRecord
  validates :first_name,        presence: true, length: {maximum: 50}
  validates :last_name,         presence: true, length: {maximum: 50}
  validates :username,          presence: true, length: {maximum: 50}, uniqueness: true
  validates :password,          presence: true, length: {maximum: 200}

  has_many :categories
  has_many :pictures

  before_save :encrypt_password

  def encrypt_password
    return unless password_changed?
    self.password = Digest::SHA1.hexdigest self.password
  end

  def self.auth(username, password)
    User.where(username: username, password: Digest::SHA1.hexdigest(password)).first
  end
end