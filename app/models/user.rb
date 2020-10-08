class User < ApplicationRecord
  validates :first_name,        presence: true, length: {maximum: 50}
  validates :last_name,         presence: true, length: {maximum: 50}
  validates :username,          presence: true, length: {maximum: 50}
  validates :password,          presence: true, length: {maximum: 200}
  validates :registration_date, presence: true

  has_many :categories
  has_many :pictures
end