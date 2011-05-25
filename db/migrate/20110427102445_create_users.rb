class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login, :limit => 25
      t.string :password, :limit => 40
      t.string :salt, :limit => 40

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
