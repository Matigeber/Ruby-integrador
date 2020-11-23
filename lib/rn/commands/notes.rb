module RN
  module Commands
    module Notes
      def self.childs(path)
        Dir.each_child(path){|f| puts "note: #{f}"}
      end
      require 'rn/models/Note'
      class Create < Dry::CLI::Command
        desc 'Create a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Creates a note titled "todo" in the global book',
          '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
          'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          title = title.sub(/A"/, "").sub(/"z/, "")
          abort "this book doesn't exist" unless book.nil? or Dir.exist? book
          if book.nil?
            path = "#{Dir.pwd}/global/#{title}.rn"
          else
            book = book.sub(/A"/, "").sub(/"z/, "")
            path = "#{Dir.pwd}/#{book}/#{title}.rn"
          end
          if File.exist? path
            abort "this note already exists"
          end
          Note.create path
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          title= title.sub(/A"/, "").sub(/"z/, "")
          if book.nil?
            path = File.join(Dir.pwd,"global","#{title}.rn")
          else
            if Dir.exist? book
              path = File.join(Dir.pwd,book,"#{title}.rn")
            else
              abort "this book doesn't exists"
            end
          end
          Note.delete path
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit the content a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]

          title = title.sub(/A"/, "").sub(/"z/, "")
          #estas expresiones sacan las comillas de los extremos
          if book.nil?
            path = "#{Dir.pwd}/global/#{title}.rn"
          else
            if Dir.exist? book
              book = book.sub(/A"/, "").sub(/"z/, "")
              path = "#{Dir.pwd}/#{book}/#{title}.rn"
            else
              puts "This book doesn't exists"
            end
          end
          Note.edit path
        end
      end

      class Retitle < Dry::CLI::Command
        desc 'Retitle a note'

        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        def call(old_title:, new_title:, **options)
          book = options[:book]
          old_title = old_title.sub(/A"/, "").sub(/"z/, "")
          new_title = new_title.sub(/A"/, "").sub(/"z/, "")
          if book.nil?
            path = "#{Dir.pwd}/global"
          else
            book = book.sub(/A"/, "").sub(/"z/, "")
            abort "This book doesn't exists" unless Dir.exist? book
            path = "#{Dir.pwd}/#{book}"
          end
          oldpath = path + "/#{old_title}.rn"
          newpath = path + "/#{new_title}.rn"
          Note.retitle oldpath, newpath
        end
      end

      class List < Dry::CLI::Command
        desc 'List notes'

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

        def call(**options)
          book = options[:book]
          global = options[:global]
          path = Dir.pwd
          if global
            path = File.join(Dir.pwd,"global")
            puts "book: global"
            Notes.childs path
          elsif not book.nil?
            book = book.sub(/A"/, "").sub(/"z/, "") #esta expresion saca las comillas de los extremos
            path = File.join(Dir.pwd,book)
            if not Dir.exist? path
              abort "this book does't exists"
            end
            puts "book: #{book}"
            Notes.childs path
          else
            Dir.each_child (path) do
            |file|
              puts "Book: #{file}"
              Dir.each_child ("#{Dir.pwd}/#{file}") {|f| puts " note: #{f}"}
          end
          end
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          title = title.sub(/A"/, "").sub(/"z/, "") #esta expresion saca las comillas de los extremos
          if book.nil?
            path = File.join(Dir.pwd,'global',"#{title}.rn")
          else
            book = book.sub(/A"/, "").sub(/"z/, "")
            path = File.join(Dir.pwd,book,"#{title}.rn")
          end
          Note.show path
        end
      end
    end
  end
end
