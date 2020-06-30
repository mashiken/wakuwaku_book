class BookShelvesController < ApplicationController

  def create
		book_shelf = BookShelf.new
		book_shelves = BookShelf.where(user_id: current_user.id)
		#本棚に整理出来る書籍の数は10冊(user_id.count<=10)
		if book_shelves.count <= 9
			book_shelf.user_id = current_user.id  #user_id
			book_shelf.book_id = params[:book_id] #book_id
			book_shelf.save
			redirect_to book_shelves_path
		else
		end
	end

  def destroy
    book_shelf = BookShelf.find_by(params[:id])
    book_shelf.destroy
    redirect_to book_shelves_path
  end
end
