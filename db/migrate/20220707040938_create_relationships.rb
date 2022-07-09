class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      #customerとのアソシエーション
      t.integer :customer_id
      #フォローのためのカラム
      t.integer :following_id
      #フォロワーのための
      t.integer :follower_id

      t.timestamps
    end
  end
end
