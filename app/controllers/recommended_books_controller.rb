# frozen_string_literal: true

class RecommendedBooksController < ApplicationController
  include CommonActions
  before_action :book_serch, only: [:confirm]

  before_action :authenticate_user!
  before_action :user_is_valid?, only: %i[confirm finish show]

  def show
    @user = User.find(params[:id])
    @reviews = Review.where(user_id: params[:id])
    @recommended = RecommendedBook.where(user_id: params[:id])
    @recommended_user = RecommendedBook.where(recommended_user_id: params[:id])

    if params[:recommended_patarn] == '1'
      # オススメしたユーザを取得
      @recommended_book = RecommendedBook.where(user_id: params[:id]).page(params[:page]).reverse_order.per(10)
    elsif params[:recommended_patarn] == '2'
      # オススメされたユーザを取得
      @recommended_book = RecommendedBook.where(recommended_user_id: params[:id]).page(params[:page]).reverse_order.per(10)
    end
  end

  def confirm
    # オススメされたユーザIDを取得
    @recommended_user = User.find(params[:id])
    # MY本棚から書籍を選ぶ場合
    @book_shelves = BookShelf.where(user_id: current_user.id)
    # レビュー一覧から書籍を選ぶ場合取得
    @reviews = Review.where(user_id: current_user.id).page(params[:page]).reverse_order.per(10)
  end

  def finish
    # オススメされたユーザIDを取得
    @recommended_user = User.find(params[:id])
    @book_details = RakutenWebService::Books::Book.search(isbn: params[:book_id])
    @recommended_book = RecommendedBook.new
  end

  def create
    @recommended_book = RecommendedBook.new(recommended_book_params)
    @recommended_book.user_id = current_user.id
    if @recommended_book.save
      message = 'オススメ成功しました'
      flash[:success] = message
      redirect_to user_path(current_user) and return
    else
      # finishへrenderで返すのに必要/valitationErrorで必要
      @recommended_user = User.find(@recommended_book.recommended_user_id)
      @book_details = RakutenWebService::Books::Book.search(isbn: @recommended_book.book_id.to_i)
      render :finish and return
    end
  end

  def destroy
  end

  private

  def recommended_book_params
    params.require(:recommended_book).permit(:user_id, :recommended_user_id, :book_id, :title, :text)
  end

  def user_is_valid?
    # 退会済ユーザーに関するビューを表示させない
    user = User.find(params[:id])
    redirect_to user_path(current_user) if user.is_valid == false
  end
end
