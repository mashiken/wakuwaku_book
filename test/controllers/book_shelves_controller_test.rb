# frozen_string_literal: true

require 'test_helper'

class BookShelvesControllerTest < ActionDispatch::IntegrationTest
  test 'should get create' do
    get book_shelves_create_url
    assert_response :success
  end

  test 'should get destroy' do
    get book_shelves_destroy_url
    assert_response :success
  end
end
