class Public::RelationshipsController < ApplicationController
  before_action :authenticate_customer!

  def followings
  end

  def followers
  end
end
