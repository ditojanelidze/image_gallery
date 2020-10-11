class Picture < ApplicationRecord
  validates :image, presence: true
  validates :height, presence: true
  validates :width, presence: true

  belongs_to :user
  belongs_to :category

  has_many :similar_pictures, class_name: :Picture, foreign_key: :attached_to_id

  before_save :generate_uuid

  mount_uploader :image, PictureUploader

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end