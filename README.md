### Instalación de dependencias

Este proyecto utiliza Bundler para manejar sus dependencias. Si aún no sabés qué es eso
o cómo usarlo, no te preocupes, todo lo que necesitás saber es que Bundler se encarga de instalar las dependencias ("gemas")
al ejecutar el siguiente comando:

```bash
$ bundle install
```

> Nota: Bundler debería estar disponible en tu instalación de Ruby, pero si por algún
> motivo al intentar ejecutar el comando `bundle` obtenés un error indicando que no se
> encuentra el comando, podés instalarlo mediante el siguiente comando:
>
> ```bash
> $ gem install bundler
> ```
  
### Pasos para ejecutar aplicacion de Ruby on Rails
* 1- Ejecutar ```bundle:install``` para instalar las dependencias

* 2- Ejecutar ```RAILS_ENV=production rails db:create``` para crear la base de datos local. Motor de base de datos utilizado: ```sqlite3```

* 3- Ejecutar ```RAILS_ENV=production rails db:migrate``` para inicializar la base

* 4- Ejecutar ```RAILS_ENV=production rails s``` para correr el servidor en produccion

### Decisiones de Diseño
* Para el manejo de usuarios del sistema, se utilizo la gema "Devise"

* Para la logica y modelo de datos, se utilizaron scaffolds los cuales generan de manera automatica controladores, modelos y vistas con acciones, formando la estructura basica de un proyecto en Rails

* Para la conversion del contenido de la nota a HTML, se utilizo la gema "RedCarpet" 
 