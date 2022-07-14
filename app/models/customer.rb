class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image

  has_many :exercises, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :followings, through: :following_relationships, source: :following

  has_many :follower_relationships, class_name: "Relationship", foreign_key: "following_id"
  has_many :followers, through: :follower_relationships, source: :follower

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

  #フォローするためのメソッド
  def follow!(customer)
    following_relationships.create!(following_id: customer.id)
  end

  #フォロー外すためのメソッド
  def unfollow!(customer)
    following_relationships.find_by!(following_id: customer.id).destroy!
  end

  #フォローしているかどうか判定するメソッド
  def following?(customer)
    followings.include?(customer)
  end

  #検索方法の分岐メソッド
  def self.looks(search, word)
    if search == "perfect_match"
      @customer = Customer.where("name LIKE?","#{word}")
    elsif search == "partial_match"
      @customer = Customer.where("name LIKE?","%#{word}%")
    else
      @customer = Customer.all
    end
  end
end
