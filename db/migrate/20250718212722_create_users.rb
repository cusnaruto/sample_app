class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string  :name, null: false
      t.string  :email, null: false, index: { unique: true }
      t.string  :password_digest, null: false
      t.integer :gender, default: 0, null: false

      t.timestamps
    end
  end
end
