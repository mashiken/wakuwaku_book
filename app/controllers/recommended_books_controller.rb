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

    if params[:keyword] #オススメ確認画面内にてオススメ書籍を検索するのに使用
      if params[:search_condition] == "title"
        @books = RakutenWebService::Books::Book.search(title: params[:keyword])
      elsif params[:search_condition] == "author"
        @books = RakutenWebService::Books::Book.search(author: params[:keyword])
      end
      params[:keyword]
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
      redirect_to action: :index and return
    else
      redirect_to action: :finish and return
    end
  end

  def destroy
  end

  private

  def recommended_book_params
    params.require(:recommended_book).permit(:user_id,:recommended_user_id, :book_id,:title,:text)
  end

end
