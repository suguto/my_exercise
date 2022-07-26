class Exercise < ApplicationRecord

  has_many_attached :body_images

  belongs_to :customer
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy

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
  #いいねをしているかどうかを確かめるメソッド
  def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
  end

  #検索方法の分岐メソッド
  def self.looks(search, word)
    if search == "perfect_match"
      @exercise = Exercise.where("body LIKE?","#{word}")
    elsif search == "partial_match"
      @exercise = Exercise.where("body LIKE?","%#{word}%")
    else
      @exercise = Exercise.all
    end
  end

  #通知機能（いいね）の為の記述
  def create_notification_favorite!(current_customer)
    #既にいいねされているか検索する
    temp = Notification.where(["visitor_id = ? and visited_id = ? and exercise_id = ? and action = ?", current_customer.id, customer_id, id, 'favorite'])
    #いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_customer.active_notifications.new(
        exercise_id: id,
        visited_id: customer_id,
        action: 'favorite'
      )
      #自分の投稿へのいいねは、通知済みにする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  #通知機能（コメント）
  def create_notification_comment!(current_customer, comment_id)
    #自分以外にコメントしている人全てを取得し通知を送る
    #temp_ids = Comment.select(:customer_id).where(exercise_id: id).where.not(customer_id: current_customer.id).distinct
    #temp_ids.each do |temp_id|
      #save_notification_comment!(current_customer, comment_id, temp_id['customer_id'])
    #end
    #投稿者に通知を送る
    save_notification_comment!(current_customer, comment_id, customer_id)
  end

  def save_notification_comment!(current_customer, comment_id, visited_id)
    #コメントは複数回する事があるため、1つの投稿に複数回通知する
    notification = current_customer.active_notifications.new(
      exercise_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )

    #自分の投稿へのコメントは通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked == true
    end
    notification.save if notification.valid?
  end
end
