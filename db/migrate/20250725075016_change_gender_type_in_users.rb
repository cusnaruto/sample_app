class ChangeGenderTypeInUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :gender_integer, :integer, default: 0

    execute <<-SQL
      UPDATE users
      SET gender_integer = CASE
        WHEN gender = 'male' THEN 0
        WHEN gender = 'female' THEN 1
        WHEN gender = 'other' THEN 2
        ELSE 0
      END
    SQL

    remove_column :users, :gender

    rename_column :users, :gender_integer, :gender
  end

  def down
    add_column :users, :gender_string, :string

    execute <<-SQL
      UPDATE users
      SET gender_string = CASE
        WHEN gender = 0 THEN 'male'
        WHEN gender = 1 THEN 'female'
        WHEN gender = 2 THEN 'other'
        ELSE 'male'
      END
    SQL

    remove_column :users, :gender

    rename_column :users, :gender_string, :gender
  end
end
