class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      #customerとのアソシエーション
      t.integer :customer_id
      #exerciseとのアソシエーション
      t.integer :exercise_id

      t.timestamps
    end
  end
end
