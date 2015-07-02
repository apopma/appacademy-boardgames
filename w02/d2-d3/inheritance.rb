class Employee
  attr_accessor :name, :title, :salary, :boss

  def initialize(name, title, salary, boss)
    @name, @title, @salary, @boss = name, title, salary, boss
  end

  def bonus(multiplier)
    @salary * multiplier
  end

  def employee_salaries
    0
  end

end

class Manager < Employee
  attr_accessor :employees

  def initialize(name, title, salary, boss = nil, employees)
    super(name, title, salary, boss)
    @employees = employees
  end

  def bonus(multiplier)
    self.employee_salaries * multiplier
  end

  def employee_salaries
    total = 0

    employees.each do |employee|
      total += employee.employee_salaries + employee.salary
    end

    total
  end
end


shawna = Employee.new('shawna', 'TA', 12_000, nil)
david = Employee.new('david', 'TA', 10_000, nil)
darren = Manager.new('darren', 'TA manager', 78_000, nil, [shawna, david])
ned = Manager.new('ned', 'founder', 1_000_000, nil, [darren])

shawna.boss = darren
david.boss = darren
darren.boss = ned


p ned.bonus(5)
p darren.bonus(4)
p david.bonus(3)
