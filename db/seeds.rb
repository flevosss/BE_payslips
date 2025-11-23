# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

admin_user = User.find_or_initialize_by(email: 'michalis@flevaris.gr')

if admin_user.new_record?
  admin_user.password = 'michalisverysecure'
  admin_user.password_confirmation = 'michalisverysecure'
  admin_user.role = :admin
  
  existing_employee = Employee.find_by(bsn: '123456789')
  if existing_employee
    admin_user.employee = existing_employee
  else
    admin_user.build_employee(
      first_name: 'Michalis',
      last_name: 'Flevaris',
      department: 'Human Resources',
      date_of_birth: Date.new(1990, 1, 1),
      address: '123 Michalis Street',
      postal_code: '1234AB',
      bsn: '123456789'
    )
  end
  
  admin_user.save!
else
  unless admin_user.admin?
    admin_user.update(role: :admin)
    puts "Admin user role updated: michalis@flevaris.gr"
  end
end