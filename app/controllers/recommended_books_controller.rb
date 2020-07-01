# frozen_string_literal: true

class RecommendedBooksController < ApplicationController
  def index
  end

  def create
  end

  def confirm
    #オススメされたユザーIDを取得
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
  end

  def destroy
  end
end
