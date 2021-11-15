require "test_helper"

class BookInstancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book_instance = book_instances(:one)
  end

  test "should get index" do
    get book_instances_url
    assert_response :success
  end

  test "should get new" do
    get new_book_instance_url
    assert_response :success
  end

  test "should create book_instance" do
    assert_difference('BookInstance.count') do
      post book_instances_url, params: { book_instance: { book_id: @book_instance.book_id, checkout_at: @book_instance.checkout_at, due_at: @book_instance.due_at, lended_by_id: @book_instance.lended_by_id, purchased_at: @book_instance.purchased_at, reserved_by_id: @book_instance.reserved_by_id, returned_at: @book_instance.returned_at, shelfmark: @book_instance.shelfmark } }
    end

    assert_redirected_to book_instance_url(BookInstance.last)
  end

  test "should show book_instance" do
    get book_instance_url(@book_instance)
    assert_response :success
  end

  test "should get edit" do
    get edit_book_instance_url(@book_instance)
    assert_response :success
  end

  test "should update book_instance" do
    patch book_instance_url(@book_instance), params: { book_instance: { book_id: @book_instance.book_id, checkout_at: @book_instance.checkout_at, due_at: @book_instance.due_at, lended_by_id: @book_instance.lended_by_id, purchased_at: @book_instance.purchased_at, reserved_by_id: @book_instance.reserved_by_id, returned_at: @book_instance.returned_at, shelfmark: @book_instance.shelfmark } }
    assert_redirected_to book_instance_url(@book_instance)
  end

  test "should destroy book_instance" do
    assert_difference('BookInstance.count', -1) do
      delete book_instance_url(@book_instance)
    end

    assert_redirected_to book_instances_url
  end
end
