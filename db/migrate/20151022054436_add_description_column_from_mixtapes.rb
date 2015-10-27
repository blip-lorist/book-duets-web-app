class AddDescriptionColumnFromMixtapes < ActiveRecord::Migration
  def change
    add_column :mixtapes, :description, :string
  end
end
