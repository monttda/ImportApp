class RemoveKindFromOperation < ActiveRecord::Migration
  def change
    remove_column :operations, :kind, :string
  end
end
