class AddBalanceToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :balance, :float, null: false

    add_check_constraint :accounts, 'balance >= 0', name: 'validate_balance'
  end
end
