class Note

  attr_accessor :title, :book

  def initialize title, book
    self.title = Helper.format_name(title)
    self.book = book
  end

  def path extension
    "#{book.path}/#{title}.#{extension}"
  end

  def create
    begin
      File.new(self.path("rn"),'w+') unless File.exist? self.path"rn"
      #no seria bueno con una excepcion me parece
      puts "Note created successfully"
    rescue Errno::EINVAL
      puts 'the name of the notes cant included some special caracters '
    end
  end

  def delete
    File.delete self.path("rn")
  end

  def edit
    TTY::Editor.open self.path "rn"
  end

  def retitle (new_path)
    File.rename(self.path("rn"),new_path)
  end

  def show
    File.foreach(self.path("rn")) {|line| puts line}
  end

  def content_note
    data = ""
    File.foreach(self .path("rn")) {|line| data += line + "\n"}
    data
  end

  def transform_to_html
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    render = markdown.render(self.content_note)
    File.new(self.path("html"),"w+").write(render)
  end
  
end
