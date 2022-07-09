class Exercise < ApplicationRecord
  
  has_one_attached :body_image
  
  belongs_to :customer
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
end
