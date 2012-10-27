require 'test_helper'

class PraisesControllerTest < ActionController::TestCase
  setup do
    @praise = praises(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:praises)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create praise" do
    assert_difference('Praise.count') do
      post :create, praise: {  }
    end

    assert_redirected_to praise_path(assigns(:praise))
  end

  test "should show praise" do
    get :show, id: @praise
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @praise
    assert_response :success
  end

  test "should update praise" do
    put :update, id: @praise, praise: {  }
    assert_redirected_to praise_path(assigns(:praise))
  end

  test "should destroy praise" do
    assert_difference('Praise.count', -1) do
      delete :destroy, id: @praise
    end

    assert_redirected_to praises_path
  end
end
