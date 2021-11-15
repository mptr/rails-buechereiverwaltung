class CreateBookInstances < ActiveRecord::Migration[6.1]
  def change
    create_table :book_instances do |t|
      t.references :book, null: false, foreign_key: true
      t.string :shelfmark
      t.date :purchased_at
      t.references :lended_by, null: true, foreign_key: { to_table: 'users'}
      t.references :reserved_by, null: true, foreign_key: { to_table: 'users'}
      t.datetime :checkout_at
      t.date :due_at
      t.datetime :returned_at

      t.timestamps
    end
  end
end
