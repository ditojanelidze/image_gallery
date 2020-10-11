class Category < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}, uniqueness: true
  belongs_to :user

  has_many :pictures, dependent: :destroy
end