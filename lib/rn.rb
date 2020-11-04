module RN
  autoload :VERSION, 'rn/version'
  autoload :Commands, 'rn/commands'

  # Agregar aquí cualquier autoload que sea necesario para que se cargue las clases y
  # módulos del modelo de datos.
  # Por ejemplo:
  # autoload :Note, 'rn/note'
  #-------------------CAJON DE NOTAS--------------------------------------------
    Dir.mkdir("#{Dir.home}/.my_rns") and Dir.mkdir("#{Dir.home}/.my_rns/global") unless Dir.exist? "#{Dir.home}/.my_rns"
    Dir.chdir("#{Dir.home}/.my_rns")
end
