class CreateAuthors < ActiveRecord::Migration[6.1]
  def change
    create_table :authors do |t|
      t.string :family_name
      t.string :given_name
      t.text :affiliation

      t.timestamps
    end
  end
end
