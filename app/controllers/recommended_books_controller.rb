# frozen_string_literal: true

class RecommendedBooksController < ApplicationController

  def show
    @user = User.find(params[:id])
    @reviews = Review.where(user_id: params[:id])
    @recommended = RecommendedBook.where(user_id: params[:id])
    @recommended_user = RecommendedBook.where(recommended_user_id: params[:id])

    if params[:recommended_patarn] == "1"
      #オススメしたユーザを取得
      @recommended_book = RecommendedBook.where(user_id: params[:id])
    elsif params[:recommended_patarn] == "2"
      #オススメされたユーザを取得
      @recommended_book = RecommendedBook.where(recommended_user_id: params[:id])
    end
  end

  def confirm
    #オススメされたユーザIDを取得
    @recommended_user = User.find(params[:id])
    #MY本棚から書籍を選ぶ場合
    @book_shelves = BookShelf.where(user_id: current_user.id)
    #レビュー一覧から書籍を選ぶ場合取得
    @reviews = Review.where(user_id: current_user.id)

    if params[:keyword] == "" #キーワード空欄の場合
      flash.now[:notice] = '申し訳ございません。お探しの商品が見つかりませんでした。もう一度、ラジオボタン「書籍タイトル」または「著者名」にチェックの上、検索ワードの入力をお願いします。'
    else
      @books_full = [] #配列を用意
      if params[:search_condition] == "title"
        books = RakutenWebService::Books::Book.search(title: params[:keyword])
        #検索結果にgem kaminariにてpagenationを追加する。
        books.all.each do |book| #books.allで検索結果の全ての商品単位を表示
          @books_full.push(book)
        end
      elsif params[:search_condition] == "author"
        books = RakutenWebService::Books::Book.search(author: params[:keyword])
        #検索結果にgem kaminariにてpagenationを追加する。
        books.all.each do |book| #books.allで検索結果の全ての商品単位を表示
          @books_full.push(book)
        end
      else
        flash.now[:notice] = '申し訳ございません。お探しの商品が見つかりませんでした。もう一度、ラジオボタン「書籍タイトル」または「著者名」にチェックの上、検索ワードの入力をお願いします。'
      end

      if @books_full.present?
        @books = Kaminari.paginate_array(@books_full, total_count: @books_full.count ).page(params[:page])
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
    recommended_book = RecommendedBook.new(recommended_book_params)
    recommended_book.user_id = current_user.id
    if recommended_book.save
      redirect_to user_path(current_user) and return
    else
      render :finish and return
    end
  end

  def destroy
  end

  private

  def recommended_book_params
    params.require(:recommended_book).permit(:user_id,:recommended_user_id, :book_id,:title,:text)
  end

end
