ActiveAdmin.register User do
  # actions :all

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :nickname, :gender, :age, :profession, :profile, :is_valid, :image_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :nickname, :gender, :age, :profession, :profile, :is_valid, :image_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  # 全てのパラメーターを許可する。
  permit_params { User.attribute_names.map(&:to_sym) }
end
