require 'rails_helper'
require 'pry'

describe 'ユーザー認証のテスト' do
  describe 'ユーザー新規登録' do
    before do
      visit new_user_registration_path
    end
    context '新規登録画面に遷移' do
      it '新規登録に成功する' do
        fill_in 'user[nickname]', with: Faker::Lorem.characters(5)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button '登録する'

        expect(page).to have_content 'アカウント登録が完了しました。'
      end
      it '新規登録に失敗する' do
        fill_in 'user[nickname]', with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: ''
        click_button '登録する'

        expect(page).to have_content 'エラーが発生したため ユーザー は保存されませんでした'
      end
    end
  end
  describe 'ユーザーログイン' do
    let!(:user) { create(:user) }
    before do
      visit new_user_session_path
    end
    context 'ログイン画面に遷移' do
      it 'ログインに成功する' do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'

        expect(page).to have_content 'ログインしました。'
      end

      it 'ログインに失敗する' do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'

        expect(current_path).to eq(new_user_session_path)
      end
    end
  end
end

describe 'ユーザーのテスト' do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe '編集のテスト' do
    context '自分の編集画面への遷移' do
      it '遷移できる' do
        visit edit_user_path(user)
        expect(current_path).to eq('/users/' + user.id.to_s + '/edit')
      end
    end
    context '他人の編集画面への遷移' do
      it '遷移できない' do
        visit edit_user_path(user2)
        expect(current_path).to eq('/users/' + user.id.to_s)
      end
    end

    context '表示の確認' do
      before do
        visit edit_user_path(user)
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[image]'
      end
      it '名前編集フォームに自分のニックネームが表示される' do
        expect(page).to have_field 'user[nickname]', with: user.nickname
      end
      it '自己紹介編集フォームに自分のプロフィールが表示される' do
        expect(page).to have_field 'user[profile]', with: user.profile
      end
      it '編集に成功する' do
        fill_in 'user[gender]', with: '男性'
        fill_in 'user[age]', with: 23
        fill_in 'user[profession]', with: '公務員'
        click_button '登録する'
        expect(page).to have_content 'プロフィール編集完了しました。'
        expect(current_path).to eq('/users/' + user.id.to_s)
      end
      it '編集に失敗する' do
        fill_in 'user[nickname]', with: ''
        click_button '登録する'
        expect(page).to have_content 'のエラーです。'
        expect(current_path).to eq('/users/' + user.id.to_s)
      end
    end
  end

  describe '一覧画面のテスト' do
    before do
      visit users_path
    end
    context '表示の確認' do
      it 'Usersと表示される' do
        expect(page).to have_content('ユーザー一覧')
      end
      it '自分と他の人の名前が表示される' do
        expect(page).to have_content user.nickname
        expect(page).to have_content user2.nickname
      end
      it 'showリンクが表示される' do
        expect(page).to have_link '', href: user_path(user)
        expect(page).to have_link '', href: user_path(user2)
      end
    end
  end
  describe '詳細画面のテスト' do
    before do
      visit user_path(user)
    end
    context '表示の確認' do
      it 'プロフィールと表示される' do
        expect(page).to have_content('プロフィール')
      end
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
      it 'ユーザー編集へのリンク' do
        expect(page).to have_link 'プロフィール情報を編集する', href: edit_user_path(user)
      end
      it 'wakuwaku-bookを退会する' do
        expect(page).to have_link 'wakuwaku-bookを退会する', href: confirm_users_path
      end
    end
  end
end
