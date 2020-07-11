# frozen_string_literal: true

class RecommendedBooksController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_valid?, only: [:confirm, :finish, :show]

  def show
    @user = User.find(params[:id])
    @reviews = Review.where(user_id: params[:id])
    @recommended = RecommendedBook.where(user_id: params[:id])
    @recommended_user = RecommendedBook.where(recommended_user_id: params[:id])

    if params[:recommended_patarn] == "1"
      #オススメしたユーザを取得
      @recommended_book = RecommendedBook.where(user_id: params[:id]).page(params[:page]).per(10)
    elsif params[:recommended_patarn] == "2"
      #オススメされたユーザを取得
      @recommended_book = RecommendedBook.where(recommended_user_id: params[:id]).page(params[:page]).per(10)
    end
  end

  def confirm
    #オススメされたユーザIDを取得
    @recommended_user = User.find(params[:id])
    #MY本棚から書籍を選ぶ場合
    @book_shelves = BookShelf.where(user_id: current_user.id)
    #レビュー一覧から書籍を選ぶ場合取得
    @reviews = Review.where(user_id: current_user.id).page(params[:page]).per(2)

    if params[:keyword] == ""
      flash.now[:notice] = '申し訳ございません。お探しの商品が見つかりませんでした。もう一度、ラジオボタン「書籍タイトル」または「著者名」にチェックの上、検索ワードの入力をお願いします。'
    else
      if params[:search_condition] == "title"

        books = RakutenWebService::Books::Book.search(title: params[:keyword]) #titleで検索
        @books_full = []
        #配列を用意(kaminari/pagenation)

        books.all.each do |book|   #books.allで検索結果の全ての商品単位を表示
          @books_full.push(book)   #books.allを切り分けたbookを1つずつ配列へ挿入
        end

        if @books_full.present?    #結果として配列にデータがあるか？あればpagination設定 無しならErrorMessage
          @books = Kaminari.paginate_array(@books_full, total_count: @books_full.count ).page(params[:page])
        else
          flash.now[:notice] = '申し訳ございません。お探しの商品が見つかりませんでした。もう一度、検索ワードの入力をお願いします。'
        end

      elsif params[:search_condition] == "author"
        books = RakutenWebService::Books::Book.search(author: params[:keyword]) #authorで検索
        @books_full = []
        #配列を用意(kaminari/pagenation)

        books.all.each do |book|   #books.allで検索結果の全ての商品単位を取得
          @books_full.push(book)   #books.allを切り分けたbookを1つずつ配列へ挿入
        end

        if @books_full.present?    #結果として配列にデータがあるか？あればpagination設定 無しならErrorMessage
          @books = Kaminari.paginate_array(@books_full, total_count: @books_full.count ).page(params[:page])
        else
          flash.now[:notice] = '申し訳ございません。お探しの商品が見つかりませんでした。もう一度、検索ワードの入力をお願いします。'
        end
      end
    end
  end

  def finish
    #オススメされたユーザIDを取得
    @recommended_user = User.find(params[:id])
    @book_details = RakutenWebService::Books::Book.search(isbn: params[:book_id])
    @recommended_book = RecommendedBook.new
  end

  def create
    @recommended_book = RecommendedBook.new(recommended_book_params)
    @recommended_book.user_id = current_user.id
    if @recommended_book.save
      flash[:notice] = 'オススメ成功しました'
      redirect_to user_path(current_user) and return
    else
      #finishへrenderで返すのに必要/valitationErrorで必要
      @recommended_user = User.find(@recommended_book.recommended_user_id)
      @book_details = RakutenWebService::Books::Book.search(isbn: @recommended_book.book_id.to_i)
      render :finish and return
    end
  end

  def destroy
  end

  private

  def recommended_book_params
    params.require(:recommended_book).permit(:user_id,:recommended_user_id, :book_id,:title,:text)
  end

  def user_is_valid?
    #退会済ユーザーに関するビューを表示させない
    user = User.find(params[:id])
    if user.is_valid == false
      redirect_to user_path(current_user)
    end
  end
end
