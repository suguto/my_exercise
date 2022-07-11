class Favorite < ApplicationRecord

  belongs_to :exercise
  belongs_to :customer

end
