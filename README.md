# Api Resto para Administración y almacenamiento de la información (SISTEMAS)

Microservicio para **sistemas**.  Aquí se podrán agregar nuevas funcionalidades siguiendo la misma lógica con la que ya se viene trabajando el sistema, la seguridad esta establecida mediante JWT.

no se permiten cambios en los archivos *.properties.
Con que cuenta:

- Registro de chequeo de mantenimiento:
    - lista de preguntas con si/no
    - registro placa equipo
    - firma usuario, firma cliente

# Tener en cuenta

A la hora de realizar cambios y evitar inconvenientes ignorar los archivos **.properties** mediante el siguiente comando:
```bash 
git update-index --assume-unchanged src/main/resources/application.properties
```  
- desactivar el comando anterior para tomar los cambios del archivo application.properties
```bash  
git update-index --no-assume-unchanged src/main/resources/application.properties
```
