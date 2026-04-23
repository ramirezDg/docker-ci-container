# PHP CI Dev — XAMPP-like PHP 7.4 Development Environment

A ready-to-use PHP development stack built for developers coming from XAMPP. Drop your projects into `src/` and they're served instantly — no configuration needed.

## What's included

| Service     | Version          | Port  |
|-------------|------------------|-------|
| PHP-FPM     | 7.4.33 (Alpine)  | —     |
| Nginx       | stable-alpine    | 8888  |
| MariaDB     | 10.5             | 3307  |
| phpMyAdmin  | latest           | 8081  |
| Composer    | 2.8              | —     |

### PHP extensions pre-installed

`pdo` · `pdo_mysql` · `mysqli` · `gd` · `zip` · `xml` · `mbstring` · `bcmath` · `opcache`

---

## Quick start

### 1. Clone the repository

```bash
git clone https://github.com/<your-user>/docker-ci-container.git
cd docker-ci-container
```

### 2. Create your `.env` file

```bash
cp .env.example .env
```

Edit `.env`:

```env
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=mydb
MYSQL_USER=dev
MYSQL_PASSWORD=secret
PMA_ARBITRARY=1
```

### 3. Add your PHP projects

Place your projects inside the `src/` folder. Each subfolder becomes a project accessible by name:

```
src/
├── myapp/
│   └── index.php
└── another-project/
    └── index.php
```

### 4. Start the stack

```bash
docker compose up -d
```

| URL                          | What                   |
|------------------------------|------------------------|
| http://localhost:8888        | Project listing (htdocs-style) |
| http://localhost:8888/myapp  | Your project           |
| http://localhost:8081        | phpMyAdmin             |

---

## URL routing

Works like XAMPP `htdocs`. The first path segment maps to the project folder:

```
http://localhost:8888/myapp/users/list
→ src/myapp/index.php?...
```

No `.htaccess` tricks needed — Nginx handles the rewrite automatically.

---

## Database connection

Connect from PHP using these credentials (internal Docker network):

```php
$host = 'db';       // service name inside Docker network
$port = 3306;       // internal port
$user = 'dev';      // MYSQL_USER from .env
$pass = 'secret';   // MYSQL_PASSWORD from .env
$db   = 'mydb';     // MYSQL_DATABASE from .env
```

> **Note:** MariaDB is exposed on port `3307` on your host machine to avoid conflicts with a local MySQL/XAMPP running on `3306`.

---

## Run Composer

```bash
docker compose run --rm composer install
docker compose run --rm composer require vendor/package
```

---

## PHP configuration defaults

| Setting               | Value   |
|-----------------------|---------|
| `post_max_size`       | 1024M   |
| `upload_max_filesize` | 1024M   |
| `memory_limit`        | 1024M   |
| `max_execution_time`  | 900s    |
| `max_input_time`      | 900s    |

---

## Supported platforms

| Architecture | Supported |
|--------------|-----------|
| `linux/amd64`  | ✅ x86-64 (Intel/AMD) |
| `linux/arm64`  | ✅ Apple Silicon, AWS Graviton |
| `linux/arm/v7` | ✅ Raspberry Pi 3/4 |

---

## Tags

| Tag         | Description                   |
|-------------|-------------------------------|
| `latest`    | Latest stable build from main |
| `1.0.0`     | Pinned version                |
| `1.0`       | Minor version track           |

---

## Use only the PHP image

If you want to use just the PHP-FPM image in your own `docker-compose.yml`:

```yaml
services:
  php:
    image: <your-dockerhub-user>/php-ci-dev:latest
    volumes:
      - ./src:/var/www/html
```

---

## License

MIT — use it freely in personal and commercial projects.
