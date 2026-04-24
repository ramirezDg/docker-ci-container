# container-codeigniter — Entorno de desarrollo PHP 7.4 tipo XAMPP

Reemplazo de XAMPP basado en Docker. Soporta múltiples proyectos PHP/CodeIgniter 3 simultáneos dentro de `src/`, cada uno con su propio repo Git, sin conflictos de puertos ni de dependencias.

## ¿Qué incluye?

| Servicio    | Versión          | Puerto |
|-------------|------------------|--------|
| PHP-FPM     | 7.4.33 (Alpine)  | —      |
| Nginx       | stable-alpine    | 8888   |
| MariaDB     | 10.5             | 3307   |
| phpMyAdmin  | latest           | 8081   |
| Composer    | 2.8              | —      |

### Extensiones PHP incluidas

`pdo` · `pdo_mysql` · `mysqli` · `gd` · `zip` · `xml` · `mbstring` · `bcmath` · `opcache`

---

## Inicio rápido

### 1. Bajá la imagen

```bash
docker pull versionamientopys/container-codeigniter:latest
```

### 2. Creá tu `docker-compose.yml`

Copiá este archivo en una carpeta vacía de tu máquina:

```yaml
version: '3.8'
services:
  nginx:
    image: nginx:stable-alpine
    container_name: nginx-ci
    restart: always
    ports:
      - 8888:80
    volumes:
      - ./src:/var/www/html
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - php
      - db
    networks:
      - ci-network

  php:
    image: versionamientopys/container-codeigniter:latest
    container_name: php-ci
    restart: always
    volumes:
      - ./src:/var/www/html
    networks:
      - ci-network

  db:
    image: mariadb:10.5
    container_name: db-ci
    restart: always
    env_file:
      - .env
    ports:
      - 3307:3306
    volumes:
      - ./mysql:/var/lib/mysql
    networks:
      - ci-network

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: phpmyadmin-ci
    ports:
      - 8081:80
    restart: always
    env_file:
      - .env
    environment:
      PMA_HOST: db
      PMA_PORT: 3306
    depends_on:
      - db
    networks:
      - ci-network

  composer:
    image: composer:2.8
    container_name: composer
    volumes:
      - ./src:/app
    working_dir: /app
    networks:
      - ci-network

networks:
  ci-network:
```

### 3. Creá tu `.env`

> Los valores de abajo son **ejemplos** — cambiálos por tus propias credenciales. Este archivo no se sube al repo (está en `.gitignore`).

```env
MYSQL_ROOT_PASSWORD=cambia-esto
MYSQL_DATABASE=mi_base
MYSQL_USER=mi_usuario
MYSQL_PASSWORD=mi_password
PMA_ARBITRARY=1
```

### 4. Creá la config de Nginx

Creá el archivo `nginx/default.conf`:

```nginx
server {
    listen 80;
    index index.php index.html;
    server_name localhost;
    root /var/www/html;
    client_max_body_size 1024M;

    location = / {
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }

    location / {
        try_files $uri $uri/ @project_fallback;
    }

    location @project_fallback {
        rewrite ^(/[^/?]+) $1/index.php?$args last;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

### 5. Levantá el stack

```bash
docker compose up -d
```

| URL | Qué es |
|-----|--------|
| http://localhost:8888 | Listado de proyectos (estilo htdocs) |
| http://localhost:8888/miapp | Tu proyecto |
| http://localhost:8081 | phpMyAdmin |

---

## Estructura de carpetas

```
mi-proyecto/
├── docker-compose.yml
├── .env
├── nginx/
│   └── default.conf
├── src/
│   ├── miapp/
│   │   └── index.php
│   └── otro-proyecto/
│       └── index.php
└── mysql/          ← generado automáticamente por MariaDB
```

---

## Ruteo de URLs

Funciona como el `htdocs` de XAMPP. El primer segmento de la URL mapea a la carpeta del proyecto:

```
http://localhost:8888/miapp/usuarios/lista
→ src/miapp/index.php?...
```

Sin `.htaccess` — Nginx maneja el rewrite automáticamente.

---

## Conexión a la base de datos

Desde PHP, usá estas credenciales (red interna de Docker):

```php
$host = 'db';      // nombre del servicio en la red Docker
$port = 3306;      // puerto interno
$user = 'dev';     // MYSQL_USER del .env
$pass = 'secret';  // MYSQL_PASSWORD del .env
$db   = 'mydb';    // MYSQL_DATABASE del .env
```

> **Nota:** MariaDB está expuesto en el puerto `3307` en tu máquina para no chocar con un MySQL/XAMPP local en `3306`.

---

## Usar Composer

```bash
docker compose run --rm composer install
docker compose run --rm composer require vendor/paquete
```

---

## Configuración PHP por defecto

| Parámetro             | Valor  |
|-----------------------|--------|
| `post_max_size`       | 1024M  |
| `upload_max_filesize` | 1024M  |
| `memory_limit`        | 1024M  |
| `max_execution_time`  | 900s   |
| `max_input_time`      | 900s   |

---

## Plataformas soportadas

| Arquitectura   | Soporte |
|----------------|---------|
| `linux/amd64`  | ✅ Intel/AMD (x86-64) |
| `linux/arm64`  | ✅ Apple Silicon, AWS Graviton |
| `linux/arm/v7` | ✅ Raspberry Pi 3/4 |

---

## Tags disponibles

| Tag      | Descripción                      |
|----------|----------------------------------|
| `latest` | Última build estable desde main  |
| `1.0.0`  | Versión fija                     |
| `1.0`    | Track de versión menor           |

---

## Código fuente

GitHub: [Proyectos-y-Soluciones-T-I/container-codeigniter](https://github.com/Proyectos-y-Soluciones-T-I/container-codeigniter)

---

## Licencia

MIT
