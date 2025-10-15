class CreateVacationRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :vacation_requests do |t|
      t.references :employee, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.text :reason
      t.integer :status

      t.timestamps
    end
  end
end
