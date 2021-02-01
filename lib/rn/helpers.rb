class Helper

  def self.global_book
    return 'global'
  end

  def self.format_name(name)
    name.sub(/A"/, "").sub(/"z/, "")
  end

  def self.book_exists? name
    abort("This book doesn't exist") unless Dir.exist? name
  end

  def self.note_exists? path
    if File.exist? path
      abort("This note already exists")
    end
  end

  def self.base_path
    return File.join(Dir.home, "/.my_rns/")
  end

  def self.validate_file(path)
    if not File.exist? path
      abort "this note doesn't exists"
    end
  end

  def self.check_file_name(title)
    if ! /^[\w\-. ]+$/m.match?(title) or title.include? "\n"
      abort "The title: #{title} cant included some special caracters"
    end
  end

  def self.check_folder_name(name)
    if ! /^[\w\-. ]+$/m.match?(name)
      abort "the name: #{name} cant included some special caracters"
    end
  end

  def self.book_help(book)
    if book.nil?
      Book.new(Helper.global_book)
    elsif Helper.book_exists? book
      Book.new(book)
    end
  end
end
