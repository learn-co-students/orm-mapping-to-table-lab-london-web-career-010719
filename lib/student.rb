class Student
  attr_accessor :name, :grade
  attr_reader :id

  @@all = []

  def initialize(name, grade)
    @name = name
    @grade = grade

    self.class.all << self
  end

  def self.all
    @@all
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, name, grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").flatten[0]
  end

  def self.create(name:, grade:)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end
end
