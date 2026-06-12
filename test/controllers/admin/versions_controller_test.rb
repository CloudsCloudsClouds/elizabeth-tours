require "test_helper"

class Admin::VersionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin
    PaperTrail.request.whodunnit = users(:admin).id.to_s
  end

  test "requires admin" do
    sign_out
    sign_in_as(users(:one))
    get admin_versions_url
    assert_redirected_to root_url
  end

  test "index" do
    get admin_versions_url
    assert_response :success
  end

  test "index filters by item_type" do
    get admin_versions_url, params: { item_type: "Tour" }
    assert_response :success
  end

  test "index filters by event" do
    get admin_versions_url, params: { event: "create" }
    assert_response :success
  end

  test "index with page param" do
    get admin_versions_url, params: { page: 1 }
    assert_response :success
  end

  test "show" do
    tour = Tour.create!(name: "Versioned", description: "Test", base_price: 100)
    version = tour.versions.last
    get admin_version_url(version)
    assert_response :success
  end

  test "show displays changes for updated record" do
    tour = tours(:one)
    tour.update!(name: "Changed Name")
    version = tour.versions.last
    get admin_version_url(version)
    assert_response :success
  end

  test "show displays deleted data for destroyed record" do
    tour = Tour.create!(name: "ToDelete", description: "Gone", base_price: 50)
    tour.destroy!
    version = PaperTrail::Version.where(item_type: "Tour", event: "destroy").last
    get admin_version_url(version)
    assert_response :success
  end
end
