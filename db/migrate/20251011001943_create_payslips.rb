class CreatePayslips < ActiveRecord::Migration[8.0]
  def change
    create_table :payslips do |t|
      t.string :unique_number
      t.references :employee, null: false, foreign_key: true
      t.date :date
      t.date :start_period
      t.date :end_period
      t.date :pay_date
      t.decimal :salary
      t.references :generated_by, null: false, foreign_key: { to_table: :users }
      t.datetime :generated_at
      t.text :notes

      t.timestamps
    end
  end
end
