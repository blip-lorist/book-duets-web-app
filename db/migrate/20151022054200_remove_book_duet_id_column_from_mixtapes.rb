class RemoveBookDuetIdColumnFromMixtapes < ActiveRecord::Migration
  def change
    remove_column :mixtapes, :book_duet_id
  end
end
