class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.text :body
      t.integer :scene
      t.string :video
      t.integer :goodrate
      t.integer :badrate

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
