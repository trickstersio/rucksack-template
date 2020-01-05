class CreateOperators < ActiveRecord::Migration[5.2]
  def change
    create_table :operators do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.timestamps
    end

    add_index :operators, :email, unique: true
  end
end
