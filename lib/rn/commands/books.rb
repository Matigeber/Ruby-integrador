module RN
  module Commands
    module Books
      class Create < Dry::CLI::Command
        desc 'Create a book'

        argument :name, required: true, desc: 'Name of the book'

        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]

        def call(name:, **)
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
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]

        def call(name: nil, **options)
          global = options[:global]
          if name.nil? and not global
            abort "you must enter a book name or --global"
          end
          if global or name.equal? "global"
            Dir.each_child("#{Dir.pwd}/global") do
              |file, path|
              path = File.join(Dir.pwd,"global",file)
              File.delete path
              puts "Deleted file: #{file}"
            end
          else
            if Dir.exist? name
              Dir.each_child("#{Dir.pwd}/#{name}") do
              |file, path|
                path = File.join(Dir.pwd,name,file)
                File.delete path
                puts "Deleted file: #{file}"
              end
              Dir.delete name
              puts "Book deleted successfully"
            else
              abort "this book doesn't exist"
            end
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List books'

        example [
          '          # Lists every available book'
        ]

        def call(*)
          Dir.each_child (Dir.pwd) {|file| puts "Book: #{file}"}
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def call(old_name:, new_name:, **)
          old_name = old_name.sub(/A"/, "").sub(/"z/, "")
          new_name = new_name.sub(/A"/, "").sub(/"z/, "")
          abort "global book cannot be renamed" unless not old_name == 'global'
          abort "this book cannot be renamed because a book with this name already exists" unless not Dir.exist? new_name
          begin
            FileUtils.mv(old_name,new_name)
            puts "book renamed successfully"
          rescue Errno::EINVAL
            puts 'the name of the books cant included some special caracters'
          end
        end
      end
    end
  end
end

