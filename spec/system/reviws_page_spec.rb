require 'pry'
require 'rails_helper'

RSpec.describe "Reviews", type: :system, js: true do

	let!(:user) { create(:user) }
	let!(:review) { create(:review, user: user)}
	before do
	  	visit new_user_session_path
	  	fill_in 'user[email]', with: user.email
	  	fill_in 'user[password]', with: user.password
	  	click_button 'ログイン'

	  	book_stub = RakutenWebService::Books::Book
	  	response = []
	  	response_first = RakutenWebService::Books::Book.new({
			  			"isbn":"1",
			  			"largeImageUrl":"https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/7792/9784065177792.jpg?_ex=200x200",
			  			"mediumImageUrl":"https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/7792/9784065177792.jpg?_ex=200x200",
			  			"itemUrl":"https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/7792/9784065177792.jpg?_ex=200x200",
			  			"title":"hoge",
			  			"titleKana":"hoge",
			  			"contents":"hoge",
			  			"author":"hoge",
			  			"authorKana":"hoge",
			  			"publisherName":"hoge",
			  			"size": "hoge",
			  			"itemCaption": "hoge",
	                    "salesDate": "hoge"})
		response.push(response_first)
	  	allow(book_stub).to receive(:search).and_return(response)
	end
	describe 'GET #show レビュー詳細(=各ユーザーごとのレビュー一覧)のテスト' do
	 	before do
	 		visit review_path(user)
	 	end
	 	context '画面表示確認' do
	 		it 'ビューのタイトル表示' do
	 		    expect(page).to have_content '書籍レビュー一覧'
	 		end
	 		it 'レビュー一覧/タイトル表示' do
	 			expect(page).to have_content review.title
			end
	 		it 'レビュー一覧/テキスト表示' do
	 			expect(page).to have_content review.text
	 		end
	 	end
	 	context 'リンク 表示確認' do
	 		it 'マイページへのリンク' do
	   			expect(page).to have_link user.nickname + 'さんのページ', href: user_path(user)
	 		end
	 		it '書籍レビューへのリンク' do
	   			expect(page).to have_link '書籍レビュー', href: review_path(user)
	 		end
	 		it 'オススメ数へのリンク' do
	   	        expect(page).to have_link 'オススメ数', href: recommended_book_path(user,  recommended_patarn: 1)
	 		end
	 		it 'オススメされ数へのリンク' do
	   	        expect(page).to have_link 'オススメされ数', href: recommended_book_path(user,  recommended_patarn: 2)
	 		end
	 		it 'いいねへのリンク' do
	   	        expect(page).to have_link , href: review_favorites_path(review)
	 		end
	     end
	 end

	describe '#create レビュー投稿のテスト' do
		before do
			visit book_path(review.book_id)
		end
		it '投稿に成功する' do
			fill_title = Faker::Lorem.characters(5)
			fill_text = Faker::Lorem.characters(20)
			fill_in 'review[title]', with: fill_title
		  	fill_in 'review[text]', with: fill_text
		  	find('#review_submit').click
		  	# 非同期処理を行っているかつ、expect(page)としているため、DOM操作をまってくれない。そのため5秒間だけ非同期処理実行を待つ。
		  	sleep 5
		  	expect(page).to have_content(fill_title)
		  	expect(page).to have_content(fill_text)
		end
 		it '投稿に失敗する' do
			fill_in 'review[title]', with: ""
		  	fill_in 'review[text]', with: ""
		  	find('#review_submit').click
		  	# 非同期処理を行っているかつ、expect(page)としているため、DOM操作をまってくれない。そのため5秒間だけ非同期処理実行を待つ。
		  	sleep 5
		  	expect(page).to have_content("のエラーです。")
 		end
	end
end