class CreateExercises < ActiveRecord::Migration[6.1]
  def change
    create_table :exercises do |t|
      #customerとのアソシエーション
      t.integer :customer_id
      #投稿内容を保存するカラム
      t.text :body
      #投稿画像を保存するカラム
      t.integer :body_image

      t.timestamps
    end
  end
end
