class AddFilterLeveltoBookDuets < ActiveRecord::Migration
  def change
    add_column :book_duets, :filter_level, :string, :default => "filthy"
  end
end
