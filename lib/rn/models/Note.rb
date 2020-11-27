class Note
  GLOBAL_BOOK_NAME = 'global'
  attr_accessor :title, :book

  def initialize title, book
    self.title = title
    self.book = book
  end

  def validate_path_and_book
    self.title = title.sub(/A"/, "").sub(/"z/, "")
    if book.nil?
      return File.join(Dir.pwd,GLOBAL_BOOK_NAME,"#{title}.rn")
    else
      if Dir.exist? book
        book = book.sub(/A"/, "").sub(/"z/, "")
        return File.join(Dir.pwd,book,"#{title}.rn")
      else
        abort "this book doesn't exists"
      end
    end
  end

  def validate_file(path)
    if not File.exist? path
      abort "this note already exists"
    end
  end

  def create
    path = validate_path_and_book
    if File.exist? path
      abort "this note doesn´t exists"
    end
    begin
      File.new(path,'w+')
      puts "Note created successfully"
      TTY::Editor.open path
    rescue Errno::EINVAL
      puts 'the name of the notes cant included some special caracters '
    end
  end

  def delete
    path = validate_path_and_book
    validate_file path
    File.delete path
    puts "Note deleted successfully"
  end

  def edit
    path = validate_path_and_book
    validate_file path
    TTY::Editor.open path
  end

  def retitle (new_title)
    new_title = new_title.sub(/A"/, "").sub(/"z/, "")
    oldpath = validate_path_and_book
    newpath = oldpath.gsub(title,new_title)
    if File.exist? newpath
      abort "this note cannot be renamed because a note with this name already exists"
    end
    File.rename(oldpath,newpath)
    puts "note renamed successfully"
  end

  def self.childs(path, name)
    puts "book: #{name}"
    Dir.each_child(path){|f| puts " note: #{f}"}
  end

  def self.list (book,global)
    path = Dir.pwd
    if global
      path = File.join(Dir.pwd,GLOBAL_BOOK_NAME)
      self.childs path, GLOBAL_BOOK_NAME
    elsif not book.nil?
      book = book.sub(/A"/, "").sub(/"z/, "") #esta expresion saca las comillas de los extremos
      path = File.join(Dir.pwd,book)
      if not Dir.exist? path
        abort "this book doesn't exists"
      end
      self.childs path,book
    else
      Dir.each_child (path) do
      |file|
        self.childs path + "/#{file}",file
      end
    end
  end

  def show
    path = validate_path_and_book
    validate_file path
    File.foreach(path) {|line| puts line}
    #markup = File.read path
    #Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end
end
