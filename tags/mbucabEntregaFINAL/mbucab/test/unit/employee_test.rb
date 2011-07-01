require File.dirname(__FILE__) + '/../test_helper'

class EmployeeTest < ActiveSupport::TestCase
  fixtures :employees

  def test_employee

    # instancia un objeto empleado con los datos del empleado en el archivo yml
    employee = employees(:borjas)

    employee.password="1234"

    # modifica un dato y verifica si el objeto se guarda bien si no la prueba falla
    assert employee.save

    employee2 = Employee.find_by_account("solsi")

    #busca otro empleado hy verifica
    #que no sea igual al primero

    assert_not_equal employee, employee2

    employee.account="solsi"
    #le asigna a employee2 la cuenta de employee
    #y verifica que no se pueda guardar debido a que la cuenta es unica
    assert !employee.save
    

    # elimina el objeto si no se elimina bien la prueba falla
    assert employee.destroy

  end
end
