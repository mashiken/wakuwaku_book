class RenameReommendedUserIdColumnToFavorites < ActiveRecord::Migration[5.2]
  def change
  	rename_column :favorites, :recommended_user_id, :review_id
  end
end
