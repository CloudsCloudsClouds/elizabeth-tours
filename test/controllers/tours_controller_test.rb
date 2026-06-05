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

  test "index in Spanish when locale param is es" do
    get tours_url(locale: :es)
    assert_response :success
    assert_equal "es", session[:locale]
  end

  test "index in English by default" do
    get tours_url
    assert_response :success
    assert_select "h1", "Tours"
  end

  test "locale persists in session" do
    get tours_url(locale: :es)
    assert_response :success
    assert_equal "es", session[:locale]

    get tours_url
    assert_response :success
    assert_equal "es", session[:locale]
  end

  test "invalid locale falls back to default" do
    get tours_url(locale: :fr)
    assert_response :success
    # The session value is set to the (fallback) locale when params[:locale] is present
    assert_equal "en", session[:locale]
  end
end
