class Exercise < ApplicationRecord

  has_many_attached :body_images

  belongs_to :customer
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :body, presence: true
  validate :body_images_length


  #投稿に画像を添付するメソッド
  def get_body_images(images, width, height)
    unless body_images.attached?
      file_path = Rails.root.join('app/assets/images/box3.jpg')
      body_images.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
      images.variant(resize_to_limit: [width, height]).processed
  end
  #画像投稿は4枚までのバリデーション
  def body_images_length
    if body_images.length > 4
      errors.add(:body_images, "は4枚以内にしてください")
    end
  end
end
