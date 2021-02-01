module RN
  module Commands
    module Notes


      require 'rn/models/Note'
      require 'rn/validator'
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
          Helper.check_file_name(title)
          if book.nil?
            note =Book.new(Helper.global_book).create_Note(title)
          else
            Helper.book_exist? book
            note = Book.new(book).create_Note title
          end
          Helper.note_exists? note.path "rn"
          note.create

          #note.edit
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
          book_instance = Helper.book_help book
          note = book_instance.create_Note title
          if File.exist? note.path("rn")
            note.delete
            puts "Note deleted successfully"
          else
            abort "this note doesn't exists"
          end
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
          note = Helper.book_help(book).create_Note(title)
          if File.exist? note.path "rn"
            note.edit
          else
            abort "this note doesn't exists"
          end

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
          book_instance = Helper.book_help  book
          note_old = book_instance.create_Note old_title
          note_new = book_instance.create_Note new_title
          puts(note_new.path("rn"))
          if File.exist? note_new.path "rn"
            abort "this note cannot be renamed because a note with this name already exists"
          else
            note_old.retitle note_new.path("rn")
            puts "note renamed successfully"
          end
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
          if global
            Book.new(Helper.global_book).list_notes
          elsif book.nil?
            Book.list_all
          elsif Helper.book_exists? book
            Book.new(book).list_notes
          else
            puts "The book '#{book}' doesn't exists"
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
          note = Helper.book_help(book).create_Note(title)
          if File.exist? note.path"rn"
            note.show
          else
            puts("This note doesn't exists")
          end
        end
      end

      class Export < Dry::CLI::Command
        desc 'Export notes'

        option :book, type: :string, desc: 'Book'
        option :title, type: :string, desc: 'Title of the note'
        option :global, type: :boolean, default: false, desc: 'Export only notes from the global book'

        example [
                    '                 # Export notes from all books (including the global book)',
                    '--book "My book" # Export notes from the book named "My book"',
                    '--book Memoires  # Export notes from the book named "Memoires"',
                    '--title todo     # Export note todo from the global book',
                    '--title test --book "My book" #Export note test from the book named "My book"',
                    '--global         # Export notes from the global book',
                ]

        def call(**options)
          book = options[:book]
          title = options[:title]
          global = options[:global]

          if global and title
            Book.new(Helper.global_book).create_Note(title).export
            abort("successful export")
          elsif book and title
            Book.new(book).create_Note(title).export
            abort("successful export")
          elsif global and title.nil?
            Book.new(Helper.global_book).export_childs
            abort("successful export")
          elsif book and title.nil?
            Book.new(book).export_childs
            abort("successful export")
          else
            Book.export_all
            abort("successful export")
          end

        end
      end
    end
  end
end
