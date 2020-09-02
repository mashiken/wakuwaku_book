require 'pry'
require 'rails_helper'

describe 'book_shelfのテスト' do
  let!(:user) { create(:user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'

    book_stub = RakutenWebService::Books::Book
    response = []
    response_first = RakutenWebService::Books::Book.new({
            "isbn": 3051375722187,
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

  describe '#create 本棚追加のテスト(追加成功)' do
    before do
      visit book_path(3051375722187)
    end
    it '本棚追加に成功する' do
      click_on '本棚へ追加'
      expect(page).to have_content("書籍1冊を本棚に追加しました。")
    end
  end
  describe '#create 本棚追加のテスト(追加失敗 パターン1)' do
    let!(:book_shelf) { create(:book_shelf, book_id: 3051375722187) }
    before do
      visit book_path(book_shelf.book_id)
    end
    it '本棚追加に失敗する (※既に同じ書籍が追加されている場合)' do
      click_on '本棚へ追加'
      # 非同期処理を行っているかつ、expect(page)としているため、DOM操作をまってくれない。そのため5秒間だけ非同期処理実行を待つ。
      sleep 5
      expect(page).to have_content("既に同じ書籍が本棚に追加されている為、追加出来ませんでした。")
    end
  end
  describe '#create 本棚追加のテスト(追加失敗 パターン2)' do
    let!(:book_shelf1) { create(:book_shelf) }
    let!(:book_shelf2) { create(:book_shelf) }
    let!(:book_shelf3) { create(:book_shelf) }
    let!(:book_shelf4) { create(:book_shelf) }
    let!(:book_shelf5) { create(:book_shelf) }
    let!(:book_shelf6) { create(:book_shelf) }
    let!(:book_shelf7) { create(:book_shelf) }
    let!(:book_shelf8) { create(:book_shelf) }
    let!(:book_shelf9) { create(:book_shelf) }
    let!(:book_shelf10) { create(:book_shelf) }
    before do
      visit book_path(3051375722187)
    end
    it '本棚追加に失敗する (※既に同じ書籍が追加されている場合)' do
      click_on '本棚へ追加'
      # 非同期処理を行っているかつ、expect(page)としているため、DOM操作をまってくれない。そのため5秒間だけ非同期処理実行を待つ。
      sleep 5
      expect(page).to have_content("上限10冊を超える為、追加出来ませんでした。")
    end
  end
end