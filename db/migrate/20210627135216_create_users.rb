class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :family_name
      t.string :given_name
      t.text :address
      #t.string :email
      t.string :password
      t.boolean :blocked, default: false
      t.text :remarks

      t.timestamps
    end
  end
end
