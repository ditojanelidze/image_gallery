class Category < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}
  belongs_to :user

  has_many :pictures
end