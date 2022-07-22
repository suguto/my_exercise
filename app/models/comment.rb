class Comment < ApplicationRecord

  belongs_to :customer
  belongs_to :exercise
  has_many :notifications, dependent: :destroy

  validates :comment_to, presence: true
end
