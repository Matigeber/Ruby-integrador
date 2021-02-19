class Book

  attr_accessor :name

  def initialize nombre
    self.name = Helper.format_name nombre
  end

  def path
    "#{Helper.base_path}#{name}"
  end

  def list_notes
    puts "book: #{self.name}"
    Dir.each_child(self.path){|note| puts " note: #{note}"}
  end

  def self.list_all
    Dir.each_child(Helper.base_path) do
      |book|
      self.new(book).list_notes
    end
  end

  def self.export_all
    Dir.each_child(Helper.base_path) do
      |book|
      self.new(book).export_childs
    end
  end

  def export_childs
    Dir.each_child(self.path) do
    |note|
      note = note.split(".")[0]
      Note.new(note,self).transform_to_html
    end
  end

  def create_Note(title)
    Note.new(title,self )
  end

  def delete_childs
    Dir.each_child(self.path) do
      |note|
      self.create_Note(note).delete
      puts("Deleted file: #{note}")
    end
  end

  def create
    Dir.mkdir name
  end

  def delete
    Dir.delete name
  end

  def self.list
    Dir.each_child(Helper.base_path) { |file| puts "Book: #{file}" }
  end

  def rename (new_name)
    FileUtils.mv(name,new_name)
  end
end
