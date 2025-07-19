class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.date :dob
      t.string :password
      t.string :password_confirm

      t.timestamps
    end
  end
end
