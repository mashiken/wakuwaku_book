
class BookShelvesController < ApplicationController
  before_action :authenticate_user!

  def create
		@book_shelf = BookShelf.new(book_shelves_params)
		book_shelves = BookShelf.where(user_id: current_user.id)

    #同じ書籍が既に本棚にあった場合追加させない
    book_shelves.each do |book_shelf|
    	if book_shelf.book_id == @book_shelf.book_id
        flash[:notice] = '既に同じ書籍が本棚に追加されている為、追加出来ませんでした。'
    		redirect_to book_path(@book_shelf.book_id.to_i)  and return
    	end
    end

		#本棚に整理出来る書籍の数は10冊(user_id.count<=10)
		if book_shelves.count <= 9
			@book_shelf.user_id = current_user.id
			@book_shelf.save
      flash[:notice] = '書籍1冊を本棚に追加しました。'
			redirect_to user_path(current_user)  and return
		else
      flash[:notice] = '上限10冊を超える為、追加出来ませんでした。'
			redirect_to book_path(@book_shelf.book_id.to_i)  and return
		end
	end

  def destroy
    book_shelf = BookShelf.find(params[:id])

    #非同期処理で必要な変数
    @reviews = Review.where(user_id: book_shelf.user_id)
    @recommended = RecommendedBook.where(user_id: book_shelf.user_id)
    @recommended_user = RecommendedBook.where(recommended_user_id: book_shelf.user_id)
    @user = User.find(book_shelf.user.id)

    book_shelf.destroy

    #非同期処理で必要な変数
    @book_shelves = BookShelf.where(user_id: @user.id)
  end

  private

    def book_shelves_params
		params.require(:book_shelf).permit(:user_id, :book_id)
	end
end
