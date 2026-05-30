require "test_helper"

class ToursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tour = tours(:one)
  end

  test "should get index" do
    get tours_url
    assert_response :success
  end

  test "should show tour" do
    get tour_url(@tour)
    assert_response :success
  end
end
