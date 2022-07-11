class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image

  has_many :exercises, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :name, length: {in: 1..10}
  validates :introduction, length: {maximum: 300}

  #guestログインするためのメソッド
  def self.guest
    find_or_create_by!(name: 'guest' ,email: 'guest@example.com') do |guest|
      guest.password = SecureRandom.urlsafe_base64
      guest.name = "guest"
    end
  end

  #プロフィール画像を表示させるメソッド
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/box3.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'box3.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  #customerの状態を表しています
  enum customer_style: { available: 0, quited: 1, block: 2}
end
