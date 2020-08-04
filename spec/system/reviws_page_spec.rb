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
	end
	describe 'GET #show レビュー詳細(=各ユーザーごとのレビュー一覧)のテスト' do
		context '画面表示確認' do
			it 'ビューのタイトル表示' do
			    visit review_path(user)
			    expect(page).to have_content '書籍レビュー一覧'
			end
			#it 'レビュー一覧/タイトル表示' do
			#	visit review_path(user)
			#	expect(page).to have_content review.title
			#end
			#it 'レビュー一覧/テキスト表示' do
			#	visit review_path(user)
			#	expect(page).to have_content review.text
			#end
		end
		context 'リンク 表示確認' do
			it 'マイページへのリンク' do
			    visit review_path(user)
	  			expect(page).to have_link user.nickname + 'さんのページ', href: user_path(user)
			end
			it '書籍レビューへのリンク' do
			    visit review_path(user)
	  			expect(page).to have_link '書籍レビュー', href: review_path(user)
			end
			it 'オススメ数へのリンク' do
			    visit review_path(user)
	  	        expect(page).to have_link 'オススメ数', href: recommended_book_path(user,  recommended_patarn: 1)
			end
			it 'オススメされ数へのリンク' do
			    visit review_path(user)
	  	        expect(page).to have_link 'オススメされ数', href: recommended_book_path(user,  recommended_patarn: 2)
			end
			it 'いいねへのリンク' do
			    visit review_path(user)
	  	        expect(page).to have_link , href: review_favorites_path(review)
			end
	    end
	end

	describe 'GET #create レビュー投稿のテスト' do
		it '投稿に成功する' do
		    get book_path(review.book_id)
		    expect(response).to render_template(:show)

		    post reviews_path, :params => { :review => {:user_id => user.id, :book_id => review.book_id, :title => Faker::Lorem.characters(5), :text => Faker::Lorem.characters(20)} }, xhr: true

		    expect(response.status).to eq(200)
		end
		it '投稿に成功する' do
			visit book_path(review.book_id)
			fill_in 'review[title]', with: Faker::Lorem.characters(5)
		  	fill_in 'review[text]', with: Faker::Lorem.characters(20)
		  	#fill_in 'review[book_id]', with: review.book_id, visible: false
		  	#find("input[name='review[book_id]']", visible: false).set('9784065177792')
		  	#find(:xpath, '//@id="#review_book_id"', visible: false).set('9784065177792')
		  	page.all('#review_book_id',).set('9784065177792')
		  	click_button 'レビューを送信'
		  	expect(page).to have_content 'successfully'
		end
		it '投稿に失敗する' do
			visit book_path(review.id)
　　　　　　 post reviews_path(user_id: user.id), xhr: true
		end
	end

	describe 'GET #destroy レビュー削除のテスト' do
	end
end