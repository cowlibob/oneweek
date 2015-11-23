class ChangeUserIdToString < ActiveRecord::Migration
  def up
    change_column :routes, :user_id, :string
  end

  def down
    change_column :routes, :user_id, :integer
  end
end
