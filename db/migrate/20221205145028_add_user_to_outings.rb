class AddUserToOutings < ActiveRecord::Migration[6.1]
  def change
    add_reference :outings, :user, null: false, foreign_key: true
  end
end
