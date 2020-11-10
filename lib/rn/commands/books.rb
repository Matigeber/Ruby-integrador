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
            rescue Errno::EINVAL
              puts 'Los nombres de los archivos no puede contener ninguno de los siguientes caracteres: / \ : * ? < > | " '
            end
          else
            warn "Este libro ya existe"
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
          #FUNCIONA COMO EL ORTO
          global = options[:global]
          if global or name.equal? "global"
            FileUtils.rm Dir.entries("#{Dir.pwd}/global")
          else
            FileUtils.rm_r Dir.entries("#{Dir.pwd}/#{name}")
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
          abort "El book global no se puede renombrar" unless not old_name == 'global'
          abort "Este libro/directorio no se puede renombrar ya que existe un libro con ese nombre" unless not Dir.exist? new_name
          begin
            FileUtils.mv(old_name,new_name)
          rescue Errno::EINVAL
            puts 'Los nombres de los archivos no puede contener ninguno de los siguientes caracteres: / \ : * ? < > | " '
          end
        end
      end
    end
  end
end
