class PayslipPdfGenerator
  require 'prawn'
  require 'prawn/table'

  def initialize(payslip)
    @payslip = payslip
    @employee = payslip.employee
    @pdf = Prawn::Document.new(margin: 50)
  end

  def generate
    add_header
    add_employee_and_details
    add_salary_table
    add_footer
    @pdf.render
  end

  private

  def add_header
    # PAYSLIP title centered
    @pdf.text "PAYSLIP", size: 36, style: :bold, align: :center
    @pdf.move_down 10
    
    # Payslip ID below in smaller font
    @pdf.text @payslip.unique_number, size: 12, align: :center
    @pdf.move_down 15
    
    # Horizontal line
    @pdf.stroke_horizontal_rule
    @pdf.move_down 40
  end

  def add_employee_and_details
    start_y = @pdf.cursor
    
    # Left column - Employee info
    @pdf.bounding_box([0, start_y], width: @pdf.bounds.width * 0.5) do
      @pdf.text "EMPLOYEE:", size: 11, style: :bold
      @pdf.move_down 10
      @pdf.text "#{@employee.first_name} #{@employee.last_name}", size: 10
      @pdf.move_down 5
      @pdf.text @employee.user.email, size: 10
      @pdf.move_down 5
      @pdf.text "Department: #{@employee.department || 'No department'}", size: 10
    end
    
    # Right column - Payslip details (right aligned)
    @pdf.bounding_box([@pdf.bounds.width * 0.5, start_y], width: @pdf.bounds.width * 0.5) do
      @pdf.text "DATE:", size: 10, style: :bold, align: :right
      @pdf.move_down 5
      @pdf.text @payslip.pay_date.strftime('%d.%m.%Y'), size: 10, align: :right
      @pdf.move_down 10
      
      @pdf.text "PAY PERIOD:", size: 10, style: :bold, align: :right
      @pdf.move_down 5
      @pdf.text "#{@payslip.start_period.strftime('%d.%m.%Y')} - #{@payslip.end_period.strftime('%d.%m.%Y')}", size: 10, align: :right
    end
    
    @pdf.move_down 80
  end

  def add_salary_table
    # Table with proper headers and data
    table_data = [
      ["DESCRIPTION", "AMOUNT"],
      ["Salary", "€#{format_currency(@payslip.salary)}"]
    ]
    
    @pdf.table(table_data, width: @pdf.bounds.width, cell_style: { borders: [] }) do
      row(0).font_style = :bold
      row(0).size = 11
      row(0).padding = [10, 0]
      row(0).border_width = 1
      row(0).border_color = "000000"
      row(0).borders = [:bottom]
      
      row(1).size = 10
      row(1).padding = [15, 0]
      
      column(1).align = :right
    end
    
    @pdf.move_down 30
    
    # Horizontal line before totals
    @pdf.stroke_horizontal_line(0, @pdf.bounds.width)
    @pdf.move_down 20
    
    # Total - right aligned
    @pdf.text "TOTAL   €#{format_currency(@payslip.salary)}", size: 12, style: :bold, align: :right
    
    @pdf.move_down 40
  end

  def add_footer
    if @payslip.notes.present?
      @pdf.text "NOTES:", size: 10, style: :bold
      @pdf.move_down 8
      @pdf.text @payslip.notes, size: 10
      @pdf.move_down 30
    end
    
    @pdf.move_down 50
    @pdf.text "Generated on #{Time.current.strftime('%d.%m.%Y')}", size: 8, align: :center
  end

  def format_currency(amount)
    sprintf('%.2f', amount)
  end
end

