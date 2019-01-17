class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name,grade, id = nil)
    @name = name
    @grade = grade
    @id = id

  end

  def self.create_table

    sql = <<-SQL
        CREATE TABLE IF NOT EXISTS students (
          id INTEGER PRIMARY KEY,
          name TEXT,
          grade TEXT
        );
        SQL
      DB[:conn].execute(sql)
  end

  def self.drop_table
      sql = <<-SQL
       DROP TABLE IF EXISTS students;
      SQL
      DB[:conn].execute(sql)
  end

      def save
        sql = <<-SQL
          INSERT INTO students
          (name,grade)
          VALUES (?,?)
        SQL

        DB[:conn].execute(sql, self.name, self.grade)

 # connect instance variable id to newly create table row
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
          #  [0][0] means get the 1st index from the first array and then the 1st index from the second
      end

      def self.create(name:,grade:)
          student = Student.new(name, grade)
          student.save
          student
      end

end
