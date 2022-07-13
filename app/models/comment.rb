class Comment < ApplicationRecord

  belongs_to :customer
  belongs_to :exercise

  validates :comment_to, presence: true
end
