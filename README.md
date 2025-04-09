# Guía de Uso del Repositorio `docker-ci-container`

Este repositorio contiene un entorno de desarrollo para CodeIgniter 3 utilizando contenedores Docker. A continuación, se detalla el funcionamiento de las rutas, cómo cargar la base de datos y otros aspectos importantes.

---

## Estructura del Repositorio

- **`Dockerfile`**: Archivo para construir la imagen de PHP con las extensiones necesarias.
- **`docker-compose.yml`**: Define los servicios de Docker (Nginx, PHP, MariaDB, PhpMyAdmin).
- **`nginx/default.conf`**: Configuración del servidor Nginx.
- **`my.cnf`**: Configuración personalizada para MariaDB.
- **`src/`**: Carpeta principal del proyecto CodeIgniter.
- **`mysql/`**: Carpeta donde se almacenan los datos de la base de datos.
- **`db.sql`**: Archivo SQL para inicializar la base de datos.

---

## Configuración de Rutas

### Nginx
- **Raíz del servidor**: `/var/www/html` (mapeado a `./src` en el host).
- **Archivo de configuración**: `nginx/default.conf`.
- **Puerto de acceso**: `http://localhost:8888`.

### PHP
- **Puerto de acceso interno**: `9000` (FastCGI).
- **Configuraciones personalizadas**:
  - `max_execution_time=300`
  - `memory_limit=512M`
  - `post_max_size=128M`

### MariaDB
- **Puerto de acceso**: `3310` (mapeado al puerto `3306` del contenedor).

---

## Cómo Cargar la Base de Datos

1. Coloca el archivo SQL (`db.sql`) en la raíz del repositorio.
2. El archivo será cargado automáticamente al iniciar el contenedor de MariaDB.
3. Si necesitas cargarlo manualmente:

   ```bash
   docker exec -i db-ci mysql -u <usuario> -p<contraseña> <base_de_datos> < archivo.sql
   ```

---

## Cómo Iniciar el Proyecto

1. Clona el repositorio:

   ```bash
   git clone <URL_DEL_REPOSITORIO>
   cd docker-ci-container
   ```

2. Construye e inicia los contenedores:

   ```bash
   docker-compose up --build
   ```

### Accede a los servicios:

- Aplicación: [http://localhost:8888](http://localhost:8888)
- PhpMyAdmin: [http://localhost:8081](http://localhost:8081)

---

## Notas Adicionales

### Archivos Ignorados:

- La carpeta `src/` está en el `.gitignore` para evitar subir el código fuente al repositorio.
- Los datos de la base de datos (`mysql/`) también están ignorados.

### Configuración de IDE:

- Archivos de configuración de VSCode (`.vscode/`) están ignorados en el repositorio.

### Logs:

- Los logs generados por los contenedores están ignorados (`*.log`).

---

## Comandos Útiles

- **Reiniciar contenedores**:

  ```bash
  docker-compose down && docker-compose up --build
  ```

- **Acceder al contenedor de PHP**:

  ```bash
  docker exec -it php-ci sh
  ```

- **Acceder al contenedor de MariaDB**:

  ```bash
  docker exec -it db-ci mysql -u <usuario> -p<contraseña>
  ```

- **Ver logs de Nginx**:

  ```bash
  docker logs nginx-ci
  ```

---

## Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo `license.txt` para más detalles.