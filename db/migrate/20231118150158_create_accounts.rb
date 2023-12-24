class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email
      t.integer :status, null: false, default: 0

      t.timestamps

      t.index :status
      t.index :phone_number
      t.index :email
    end
  end
end
