class Picture < ApplicationRecord
  include Magick
  validates :image, presence: true
  validates :height, presence: true
  validates :width, presence: true

  belongs_to :user
  belongs_to :category

  has_many :similar_pictures, class_name: :Picture, foreign_key: :attached_to_id

  before_save :generate_uuid
  before_save :calculate_hsla_color

  mount_uploader :image, PictureUploader

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  def calculate_hsla_color
    image = Image.read(self.image.path).first
    colors = image.color_histogram
    result = [0, 0, 0, 0]
    colors.each do |key, _|
      hsla = key.to_hsla
      result[0] += hsla[0]
      result[1] += hsla[1]
      result[2] += hsla[2]
      result[3] += hsla[3]
    end
    result.map! {|x| (x.to_d/colors.keys.count).round(2)}
    result
    self.hsla_color = result
  end
end