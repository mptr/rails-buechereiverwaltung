require "application_system_test_case"

class BookInstancesTest < ApplicationSystemTestCase
  setup do
    @book_instance = book_instances(:one)
  end

  test "visiting the index" do
    visit book_instances_url
    assert_selector "h1", text: "Book Instances"
  end

  test "creating a Book instance" do
    visit book_instances_url
    click_on "New Book Instance"

    fill_in "Book", with: @book_instance.book_id
    fill_in "Checkout at", with: @book_instance.checkout_at
    fill_in "Due at", with: @book_instance.due_at
    fill_in "Lended by", with: @book_instance.lended_by_id
    fill_in "Purchased at", with: @book_instance.purchased_at
    fill_in "Reserved by", with: @book_instance.reserved_by_id
    fill_in "Returned at", with: @book_instance.returned_at
    fill_in "Shelfmark", with: @book_instance.shelfmark
    click_on "Create Book instance"

    assert_text "Book instance was successfully created"
    click_on "Back"
  end

  test "updating a Book instance" do
    visit book_instances_url
    click_on "Edit", match: :first

    fill_in "Book", with: @book_instance.book_id
    fill_in "Checkout at", with: @book_instance.checkout_at
    fill_in "Due at", with: @book_instance.due_at
    fill_in "Lended by", with: @book_instance.lended_by_id
    fill_in "Purchased at", with: @book_instance.purchased_at
    fill_in "Reserved by", with: @book_instance.reserved_by_id
    fill_in "Returned at", with: @book_instance.returned_at
    fill_in "Shelfmark", with: @book_instance.shelfmark
    click_on "Update Book instance"

    assert_text "Book instance was successfully updated"
    click_on "Back"
  end

  test "destroying a Book instance" do
    visit book_instances_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Book instance was successfully destroyed"
  end
end
