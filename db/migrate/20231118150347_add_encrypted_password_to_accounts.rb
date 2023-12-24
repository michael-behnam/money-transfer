class AddEncryptedPasswordToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :encrypted_password, :string, null: false, default: ''
  end
end
