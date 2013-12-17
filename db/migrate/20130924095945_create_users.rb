class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end

    add_index :microposts, [:user_id, :created_at] # Active Record uses both keys at the same time
  end
end
