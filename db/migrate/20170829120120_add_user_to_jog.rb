class AddUserToJog < ActiveRecord::Migration[5.1]
  def change
    add_reference :jogs, :user, foreign_key: true
  end
end
