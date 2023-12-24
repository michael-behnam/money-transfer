class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :sender,   foreign_key: { to_table: :accounts }, null: false
      t.references :receiver, foreign_key: { to_table: :accounts }, null: false

      t.float :amount, null: false

      t.timestamps
    end

    add_check_constraint :transactions, 'amount >= 0', name: 'validate_amount'
  end
end
