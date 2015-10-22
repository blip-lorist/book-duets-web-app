class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :mixtapes, :book_duets do |t|
      # t.index [:mixtape_id, :book_duet_id]
      # t.index [:book_duet_id, :mixtape_id]
    end
  end
end
