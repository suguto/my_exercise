require "test_helper"

class Public::FavoritesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_favorites_index_url
    assert_response :success
  end

  test "should get ranking" do
    get public_favorites_ranking_url
    assert_response :success
  end
end
