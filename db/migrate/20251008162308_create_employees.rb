class CreateEmployees < ActiveRecord::Migration[8.0]
  def change
    create_table :employees do |t|
      t.string :firstname
      t.string :lastname
      t.date :date_of_birth
      t.string :address
      t.string :postcode
      t.integer :bsn

      t.timestamps
    end
  end
end
