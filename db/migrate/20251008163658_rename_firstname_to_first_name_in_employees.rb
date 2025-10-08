class RenameFirstnameToFirstNameInEmployees < ActiveRecord::Migration[8.0]
  def change
    rename_column :employees, :firstname, :first_name
    rename_column :employees, :lastname, :last_name
    rename_column :employees, :postcode, :postal_code
  end
end
