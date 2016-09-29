Sociedad Actúa
============

## Dependencias
- Ruby 2.2.4
- Rails 4.2.3

## Instalación / Configuración
1. bundle install
2. rake db:setup
3. rake db:migrate
4. rake db:seeds
5. rails server

## Deploy de la aplicación
Para el despliegue (_deploy_) de la aplicación se tiene considerado Unircorn como Web server y por defecto tiene la configuración necesaria para hacer un despliegue a Amazon Beanstalk. Para las operaciones básicas puedes usar:

- Despliegue de la aplicación: `eb deploy [nombre-entorno] --verbose`.
- Acceso por SSH a la instancia EC2 donde se ejecuta la aplicación: `eb ssh [nombre-entorno] --verbose`, puedes usar `--verbose` para ver como se ejecuta el comando `eb`.
- Imprimir las variables de entorno: `eb printenv [nombre-entorno]`.
- Ver los logs de la aplicación y Amazon EBS: `eb logs [nombre-entorno]`.
- Abrir la aplicación en el explorador: `eb open [nombre-entorno]`.
- Ver los entornos de la aplicación: `eb list [nombre-entorno]`.
- Ver el estatus del entorno: `eb status [nombre-entorno]`.

### Configurando variables de entorno
Para configurar las variables de entorno hay dos opciones:
- Configurarlas desde la vista web de AWS.
- Hacerlo por CLI: `eb setenv NOMBRE_VARIABLE=SUVALOR`

### Conectando a la RDS usando PGAdmin
Para conectarse es importante:
- Imprimir variables de entorno usando: `eb printenv [nombre-entorno]`
- Identificar los valores de conexión PG (username, password, hostname, db_name, port)
- Ir a la instancia de RDS y sus Security Group Rules asociados para agregar uno nuevo con nuestra IP
- Conectarnos desde el PG Admin

## Licencia

_Available under the license: Apache License, Version 2.0. Read the document [LICENSE](/LICENSE.md) for more information._

Creado por [Cívica Digital](https://civica.digital), 2014-2016.
