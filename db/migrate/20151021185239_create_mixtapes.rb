class CreateMixtapes < ActiveRecord::Migration
  def change
    create_table :mixtapes do |t|
      t.string "title"
      t.integer "user_id"
      t.integer "book_duet_id"
      t.string :username
      t.timestamps null: false
    end
  end
end
