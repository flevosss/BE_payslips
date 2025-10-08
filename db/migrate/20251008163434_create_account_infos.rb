class CreateAccountInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :account_infos do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :account_number
      t.string :account_name
      t.string :string

      t.timestamps
    end
  end
end
