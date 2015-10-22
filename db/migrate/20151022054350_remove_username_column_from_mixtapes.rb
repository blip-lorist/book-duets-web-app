class RemoveUsernameColumnFromMixtapes < ActiveRecord::Migration
  def change
    remove_column :mixtapes, :username
  end
end
