# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create default admin user
admin_user = User.find_or_initialize_by(email: 'admin@bookingexperts.com')
if admin_user.new_record?
  admin_user.password = 'admin123'
  admin_user.password_confirmation = 'admin123'
  admin_user.role = :admin
  
  admin_user.build_employee(
    first_name: 'Admin',
    last_name: 'User',
    department: 'Human Resources',
    date_of_birth: Date.new(1990, 1, 1),
    address: '123 Admin Street',
    postal_code: '1234AB',
    bsn: '123456789'
  )
  
  admin_user.save!
  puts "Admin user created: admin@bookingexperts.com / admin123"
end
