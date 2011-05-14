require 'test_helper'

class DocattachmentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:docattachments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create docattachment" do
    assert_difference('Docattachment.count') do
      post :create, :docattachment => { }
    end

    assert_redirected_to docattachment_path(assigns(:docattachment))
  end

  test "should show docattachment" do
    get :show, :id => docattachments(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => docattachments(:one).id
    assert_response :success
  end

  test "should update docattachment" do
    put :update, :id => docattachments(:one).id, :docattachment => { }
    assert_redirected_to docattachment_path(assigns(:docattachment))
  end

  test "should destroy docattachment" do
    assert_difference('Docattachment.count', -1) do
      delete :destroy, :id => docattachments(:one).id
    end

    assert_redirected_to docattachments_path
  end
end
