class AddUserIdColumnToBookDuets < ActiveRecord::Migration
  def change
    add_column :book_duets, :user_id, :integer
  end
end
