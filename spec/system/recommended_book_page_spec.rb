require 'pry'
require 'rails_helper'

describe 'recommended_bookのテスト' do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:review) { create(:review, user: user)}
  let!(:recommended_book) { create(:recommended_book, user: user)}
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
  describe '#show オススメ詳細ページの確認' do
    before do
      visit recommended_book_path(user,recommended_patarn: 1)
    end
    context '画面表示確認' do
      it 'ビューのタイトル表示' do
        expect(page).to have_content 'おすすめ一覧'
      end
      it 'オススメ一覧/タイトル表示' do
        expect(page).to have_content recommended_book.title
      end
      it 'オススメ一覧/本文表示' do
        expect(page).to have_content recommended_book.text
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
    end
  end
  describe '#confirm オススメ詳細ページの確認' do
    before do
      visit confirm_recommended_book_path(user2)
    end
    context '画面表示確認' do
      it 'ビューのタイトル表示' do
        expect(page).to have_content 'オススメ書籍を選ぶ'
      end
      it '宛先表示' do
        expect(page).to have_content user2.nickname + 'さんへ'
      end
    end
    context 'ラジオボタン 表示確認' do
      it '本棚書籍からオススメ' do
        find("input[value='shilf']").set(true)
        click_on '検索'
        expect(page).to have_content 'MY本棚 書籍画像'
      end
      it '「レビュー一覧からオススメ」を選択する' do
        choose 'レビュー一覧からオススメ'
        click_on '検索'
        expect(page).to have_content review.title
        expect(page).to have_content review.text
      end
      it '「オススメしたい書籍を検索する」を選択する' do
        choose 'オススメしたい書籍を検索する'
        click_on '検索'
        expect(page).to have_field('書籍タイトル')
        expect(page).to have_field('著者名')
      end
      it '書籍決定 リンクのテスト' do
        choose 'レビュー一覧からオススメ'
        click_on '検索'
        click_on '書籍決定'
        expect(page).to have_current_path finish_recommended_book_path(user2, book_id: review.book_id)
      end
    end
  end

  describe '#finish #create オススメ確定/表示/投稿テスト' do
    before do
      visit finish_recommended_book_path(user2, book_id: review.book_id)
    end
        it 'ビューのタイトル表示' do
      expect(page).to have_content 'オススメ書籍 確認フォーム'
    end
    it '投稿に成功する' do
      fill_title = Faker::Lorem.characters(5)
      fill_text = Faker::Lorem.characters(20)
      fill_in 'recommended_book[title]', with: fill_title
      fill_in 'recommended_book[text]', with: fill_text
      click_on '送信する'

      expect(page).to have_content("オススメ成功しました")
    end
    it '投稿に失敗する' do
      fill_in 'recommended_book[title]', with: ""
      fill_in 'recommended_book[text]', with: ""
      click_on '送信する'
      # 非同期処理を行っているかつ、expect(page)としているため、DOM操作をまってくれない。そのため5秒間だけ非同期処理実行を待つ。
      sleep 5
      expect(page).to have_content("のエラーです。")
    end
  end
end