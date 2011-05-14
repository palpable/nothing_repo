require 'test_helper'

class RoadShowsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:road_shows)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create road_show" do
    assert_difference('RoadShow.count') do
      post :create, :road_show => { }
    end

    assert_redirected_to road_show_path(assigns(:road_show))
  end

  test "should show road_show" do
    get :show, :id => road_shows(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => road_shows(:one).id
    assert_response :success
  end

  test "should update road_show" do
    put :update, :id => road_shows(:one).id, :road_show => { }
    assert_redirected_to road_show_path(assigns(:road_show))
  end

  test "should destroy road_show" do
    assert_difference('RoadShow.count', -1) do
      delete :destroy, :id => road_shows(:one).id
    end

    assert_redirected_to road_shows_path
  end
end
