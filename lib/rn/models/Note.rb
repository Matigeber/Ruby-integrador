class Note
  GLOBAL_BOOK_NAME = 'global'
  attr_accessor :title, :book

  def initialize title, book
    self.title = title
    self.book = book
  end

  def validate_path_and_book(extension)
    self.title = self.title.sub(/A"/, "").sub(/"z/, "")
    if book.nil?
      return File.join(Dir.pwd,GLOBAL_BOOK_NAME,"#{title}.#{extension}")
    else
      if Dir.exist? book
        self.book = self.book.sub(/A"/, "").sub(/"z/, "")
        return File.join(Dir.pwd,book,"#{title}.#{extension}")
      else
        abort "this book doesn't exists"
      end
    end
  end

  def validate_file(path)
    if not File.exist? path
      abort "this note doesn't exists"
    end
  end

  def create
    path = validate_path_and_book "rn"
    if File.exist? path
      abort "this note doesn´t exists"
    end
    begin
      File.new(path,'w+')
      puts "Note created successfully"
    rescue Errno::EINVAL
      puts 'the name of the notes cant included some special caracters '
    end
  end

  def delete
    path = validate_path_and_book "rn"
    validate_file path
    File.delete path
    puts "Note deleted successfully"
  end

  def edit
    path = validate_path_and_book "rn"
    validate_file path
    TTY::Editor.open path
  end

  def retitle (new_title)
    new_title = new_title.sub(/A"/, "").sub(/"z/, "")
    oldpath = validate_path_and_book "rn"
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
    self.extract_method(method(:childs),global,book)
  end

  def show
    path = validate_path_and_book "rn"
    validate_file path
    File.foreach(path) {|line| puts line}
  end

  def content_note
    path = validate_path_and_book "rn"
    validate_file path
    data = ""
    File.foreach(path) {|line| data += line + "\n"}
    data
  end

  def export(path=nil)
    if path.nil?
      path = validate_path_and_book "html"
    else
      path + "/#{title}.html"
    end
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    render = markdown.render(self.content_note)
    File.new(path,"w+").write(render)
  end

  def self.exportChilds(path,book)
    Dir.each_child(path) do
    |note|
      note = note.split(".")[0]
      Note.new(note,book).export
    end
  end

  def self.exportEveryNotes(global=false, book=nil )
    self.extract_method(method(:exportChilds),global,book)
  end

  def self.extract_method (function,global,book)
    path = Dir.pwd
    if global
      path = File.join(Dir.pwd,GLOBAL_BOOK_NAME)
      function.call(path,GLOBAL_BOOK_NAME)
    elsif not book.nil?
      book = book.sub(/A"/, "").sub(/"z/, "")
      path = File.join(Dir.pwd,book)
      if not Dir.exist? path
        abort "this book doesn't exist"
      end
      function.call(path,book)
    else
      Dir.each_child(path) do
      |namebook|
        function.call(path + "/#{namebook}",namebook)
      end
    end
  end
end
