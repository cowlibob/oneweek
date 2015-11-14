class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :name
      t.text :xml
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
