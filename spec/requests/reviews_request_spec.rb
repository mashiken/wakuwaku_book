require 'rails_helper'
RSpec.describe "Reviews", type: :request do
	let!(:user) { create(:user) }
	let!(:review) { create(:review, user: user)}

	before do
		login_user user
	end

	describe 'GET #show レビュー詳細(=各ユーザーごとのレビュー一覧)のテスト' do
		context '画面表示確認' do
			it 'ビューのタイトル表示' do
				visit review_path(user)
			  expect(page).to have_content '書籍レビュー一覧'
			end
			it 'レビューのタイトル表示' do
				visit review_path(user)
				expect(page).to have_content review.title
			end
			it 'レビューのテキスト表示' do
				visit review_path(user)
				expect(page).to have_content review.text
			end
		end
		context 'リンク表示確認' do
		  it 'マイページへのリンク' do
		    visit review_path(user)
  			expect(page).to have_link user.nickname + 'さんのリンク', href: user_path(user)
		  end
		  it '書籍レビューへのリンク' do
		    visit review_path(user)
  			expect(page).to have_link '書籍レビュー', href: review_path(user)
		  end
		  it 'オススメ数へのリンク' do
		    visit review_path(user)
  			expect(page).to have_link 'オススメ数', href: recommended_book_path(user)
		  end
		  it 'オススメ数へのリンク' do
		    visit review_path(user)
  			expect(page).to have_link '', href: review_favorites_path(user.review)
		  end
	  end
	end

	describe 'GET #create レビュー投稿のテスト' do
	end

	describe 'GET #destroy レビュー削除のテスト' do
	end
end