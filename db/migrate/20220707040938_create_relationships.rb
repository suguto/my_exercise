class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      #フォローのためのカラム
      t.integer :following_id
      #フォロワーのためのカラム
      t.integer :follower_id

      t.timestamps
    end
  end
end
