class CreateBookDuets < ActiveRecord::Migration
  def change
    create_table :book_duets do |t|
      t.string :musician
      t.string :author
      t.string :duet_text

      t.timestamps null: false
    end
  end
end
