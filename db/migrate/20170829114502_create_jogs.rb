class CreateJogs < ActiveRecord::Migration[5.1]
  def change
    create_table :jogs do |t|
      t.date :date
      t.integer :time
      t.integer :distance
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
