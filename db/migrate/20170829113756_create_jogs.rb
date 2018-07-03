class CreateJogs < ActiveRecord::Migration[5.1]
  def change
    create_table :jogs do |t|
      t.date :time
      t.integer :time
      t.integer :distance

      t.timestamps
    end
  end
end
