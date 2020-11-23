class Book

  def self.create (name)
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

  def self.delete (name)
    Dir.each_child("#{Dir.pwd}/#{name}") do
    |file, path|
      path = File.join(Dir.pwd,name,file)
      File.delete path
      puts "Deleted file: #{file}"
    end
    if not name.equal? "global"
      Dir.delete name
      puts "Book deleted successfully"
    end
  end

  def self.list
    Dir.each_child (Dir.pwd) {|file| puts "Book: #{file}"}
  end

  def self.rename (old_name, new_name)
    begin
      FileUtils.mv(old_name,new_name)
      puts "book renamed successfully"
    rescue Errno::EINVAL
      puts 'the name of the books cant included some special caracters'
    end
  end
end
