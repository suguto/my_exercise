class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      #customerとのアソシエーション
      t.integer :customer_id
      #exerciseとのアソシエーション
      t.integer :exercise_id
      #投稿へのコメントを保存するカラム
      t.string :comment_to

      t.timestamps
    end
  end
end
