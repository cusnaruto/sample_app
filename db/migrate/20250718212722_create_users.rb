class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, comment: "User's full name"
      t.string :email, comment: "User's email address for login"
      t.date :date_of_birth, comment: "User's date of birth"  # changed from dob
      t.string :password_digest, comment: "Encrypted password"  # changed from password

      t.timestamps
    end
  end
end
