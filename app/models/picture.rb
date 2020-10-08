class Picture < ApplicationRecord
  validates :image, presence: true
  validates :uuid, presence: true, length: {maximum: 20}
  validates :height, presence: true
  validates :width, presence: true

  belongs_to :user
  belongs_to :category
end