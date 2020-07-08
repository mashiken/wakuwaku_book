class BookShelvesController < ApplicationController
  before_action :authenticate_user!
  def create
		book_shelf = BookShelf.new(book_shelves_params)
		book_shelves = BookShelf.where(user_id: current_user.id)

    book_shelves.each do |book_shelf|
    	if book_shelf.book_id == params[:book_id]
    		redirect_to book_path(params[:book_id])  and return
    	end
    end

		#本棚に整理出来る書籍の数は10冊(user_id.count<=10)
		if book_shelves.count <= 9
			book_shelf.user_id = current_user.id  #user_id
			#book_shelf.book_id = params[:book_id] #book_id
			book_shelf.save
			redirect_to user_path(current_user)  and return
		else
			redirect_to book_path(params[:book_id])  and return
		end
	end

    def destroy
	    book_shelf = BookShelf.find_by(params[:id])
	    book_shelf.destroy
	    redirect_to user_path(current_user)
    end

  private

    def book_shelves_params
		params.require(:book_shelf).permit(:user_id, :book_id)
	end
end
