class Note

  def self.create path
    begin
      File.new(path,'w+')
      puts "Note created successfully"
      self .edit path
    rescue Errno::EINVAL
      puts 'the name of the notes cant included some special caracters '
    end
  end

  def self.delete path
    File.delete path
    puts "Note deleted successfully"
  end

  def self.edit path
    TTY::Editor.open path
  end

  def self.retitle (oldpath,newpath)
    if File.exist? newpath
      abort "this note cannot be renamed because a note with this name already exists"
    end
    File.rename(oldpath,newpath)
    puts "note renamed successfully"
  end
  #FALTA EL LIST
  def self.show path
    if not File.exist? path
      abort "this note doesn't exists"
    end
    File.foreach(path) {|line| puts line}
  end
end
