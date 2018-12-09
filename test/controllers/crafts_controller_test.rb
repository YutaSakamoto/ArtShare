require 'test_helper'

class CraftsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get crafts_index_url
    assert_response :success
  end

  test "should get new" do
    get crafts_new_url
    assert_response :success
  end

  test "should get create" do
    get crafts_create_url
    assert_response :success
  end

  test "should get listing" do
    get crafts_listing_url
    assert_response :success
  end

  test "should get pricing" do
    get crafts_pricing_url
    assert_response :success
  end

  test "should get description" do
    get crafts_description_url
    assert_response :success
  end

  test "should get photo_upload" do
    get crafts_photo_upload_url
    assert_response :success
  end

  test "should get location" do
    get crafts_location_url
    assert_response :success
  end

  test "should get update" do
    get crafts_update_url
    assert_response :success
  end

end
