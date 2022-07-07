require "test_helper"

class Public::ExercisesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_exercises_new_url
    assert_response :success
  end

  test "should get index" do
    get public_exercises_index_url
    assert_response :success
  end

  test "should get show" do
    get public_exercises_show_url
    assert_response :success
  end

  test "should get edit" do
    get public_exercises_edit_url
    assert_response :success
  end
end
