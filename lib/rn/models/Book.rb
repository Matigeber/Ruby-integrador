class Book

  GLOBAL_BOOK_NAME = 'global'

  attr_accessor :name

  def initialize nombre
    self.name = nombre.sub(/A"/, "").sub(/"z/, "")
  end

  def create
    if not Dir.exist? name
      begin
        Dir.mkdir name
        puts "book created successfully"
      rescue Errno::EINVAL
        puts 'the name of the notes cant included some special caracters'
      end
    else
      warn "this book  already exists"
    end
  end

  def delete (global)
    if global
      name = GLOBAL_BOOK_NAME
    elsif not Dir.exist? name
      abort "this book doesn't exist"
    end
    Dir.each_child("#{Dir.pwd}/#{name}") do
    |file, path|
      path = File.join(Dir.pwd,name,file)
      File.delete path
      puts "Deleted file: #{file}"
    end
    if not name.equal? GLOBAL_BOOK_NAME
      Dir.delete name
      puts "Book deleted successfully"
    end
  end

  def self.list
    Dir.each_child (Dir.pwd) {|file| puts "Book: #{file}"}
  end

  def rename (new_name)
    new_name = new_name.sub(/A"/, "").sub(/"z/, "")
    abort "global book cannot be renamed" unless not name == GLOBAL_BOOK_NAME
    abort "this book cannot be renamed because a book with this name already exists" unless not Dir.exist? new_name
    begin
      FileUtils.mv(name,new_name)
      puts "book renamed successfully"
    rescue Errno::EINVAL
      puts 'the name of the books cant included some special caracters'
    end
  end
end
