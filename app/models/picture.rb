class Picture < ApplicationRecord
  validates :image, presence: true
  validates :height, presence: true
  validates :width, presence: true

  belongs_to :user
  belongs_to :category

  before_save :generate_uuid

  mount_uploader :image, PictureUploader

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end