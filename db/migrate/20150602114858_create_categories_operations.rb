class CreateCategoriesOperations < ActiveRecord::Migration
  def change
    create_table :categories_operations do |t|
      t.references :operation, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
    end
  end
end
