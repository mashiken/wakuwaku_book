# frozen_string_literal: true

require 'test_helper'

class RecommendedBooksControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get recommended_books_index_url
    assert_response :success
  end

  test 'should get create' do
    get recommended_books_create_url
    assert_response :success
  end

  test 'should get finish' do
    get recommended_books_finish_url
    assert_response :success
  end

  test 'should get destroy' do
    get recommended_books_destroy_url
    assert_response :success
  end
end
