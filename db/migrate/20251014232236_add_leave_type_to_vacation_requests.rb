class AddLeaveTypeToVacationRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :vacation_requests, :leave_type, :integer, default: 0, null: false
  end
end
