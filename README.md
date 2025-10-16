# BookingExperts - HR Management System

A Human Resources management system built with Ruby on Rails for employee management, payslip generation, and leave request processing.

## Features

- User authentication and role-based authorization (Admin/Employee)
- Employee profile management
- Payslip generation and viewing
- Leave request submission and approval workflow
- Dashboard for admins and employees
- Bank account information management

## Tech Stack

- Ruby on Rails 8.0
- Devise (authentication)
- RubyUI/Phlex (UI components)
- PostgreSQL 
- Prawn (PDF generation)
- Tailwind CSS
- Stimulus

## Prerequisites

- Ruby 3.3.0+
- Rails 8.0.0
- Node.js 18+
- PostgreSQL 

## Installation

1. Clone the repository
git clone <repository-url>
cd bookingexperts
```

2. Install dependencies
bundle install
```

3. Setup database
rails db:create
rails db:migrate
rails db:seed
```

4. Run the application
bin/dev
```

Visit `http://localhost:3000`

## Database Schema

**User** - Authentication and authorization
- Has one Employee
- Can generate payslips (admin role)

**Employee** - Employee profile data
- Belongs to User
- Has many Payslips and VacationRequests
- Has one AccountInfo

**AccountInfo** - Bank account details
- Belongs to Employee

**Payslip** - Salary records
- Belongs to Employee and User (generated_by)
- Unique number format: PAY-YYYY-MM-XXXX

**VacationRequest** - Leave management
- Belongs to Employee
- Status: pending, approved, rejected
- Leave types: vacation, sick leave, personal, unpaid, other

## Usage

### Employees
- Login and view dashboard
- Submit leave requests
- View and download payslips
- Update profile information

### Admins
- Manage employees (create, edit, delete)
- Generate payslips
- Approve/reject leave requests
- View all employee data

## Deployment

Configured for Render.com deployment.

Environment variables:
- `RAILS_MASTER_KEY` - Rails encrypted credentials
- `DATABASE_URL` - PostgreSQL connection string

## Project Structure

```
app/
├── controllers/
├── models/
├── views/
├── components/
├── services/
└── jobs/

config/
├── routes.rb
├── database.yml
└── environments/
```

## License

Proprietary software
