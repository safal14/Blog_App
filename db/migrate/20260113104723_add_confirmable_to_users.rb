class AddConfirmableToUsers < ActiveRecord::Migration[8.0]  # Change [8.0] to match your Rails version (check rails -v)
  def up
    add_column :users, :confirmation_token,   :string
    add_column :users, :confirmed_at,         :datetime
    add_column :users, :confirmation_sent_at, :datetime

    # Optional: Only add this if you want reconfirmable (email changes require confirmation)
    # add_column :users, :unconfirmed_email,  :string

    # Unique index on token (important for security/performance)
    add_index :users, :confirmation_token, unique: true

    # Optional: Mark ALL existing users as already confirmed (so they don't get blocked)
    # Skip this if you have no users yet or want to force confirmation on old accounts
    # User.update_all(confirmed_at: Time.current)
  end

  def down
    remove_index :users, :confirmation_token
    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at

    # If you added reconfirmable:
    # remove_column :users, :unconfirmed_email
  end
end