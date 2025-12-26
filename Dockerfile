FROM php:8.3-fpm-alpine

# 1. 安裝 Nginx, Supervisor, 以及 WP 必備擴充 (這部分基本沒問題)
RUN apk add --no-cache \
    nginx \
    supervisor \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    icu-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql zip intl opcache

# 設定工作目錄
WORKDIR /var/www/html

# 2. 下載 WordPress (維持原樣，但注意下方的修改)
RUN curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz \
    && tar -xzf wordpress.tar.gz --strip-components=1 \
    && rm wordpress.tar.gz

# ----------------- 【以下為關鍵修改處】 -----------------

# 修改 A：將地端的專案內容（包含你寫好的 wp-config.php 和 version.html）複製進映像檔
# 這樣你的自定義設定才會覆蓋掉 WordPress 原生的空檔案
COPY . /var/www/html

# 修改 B：確保在 COPY 之後才進行權限設定
# 這樣你從地端傳上去的檔案（例如 version.html）才會有正確的讀取權限
RUN chown -R www-data:www-data /var/www/html

# 修改 C：將配置文件的複製與主程式分開（優化層級）
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# ------------------------------------------------------

EXPOSE 80

# 建議使用 ENTRYPOINT 配合 CMD，確保容器啟動時 supervisor 一定會執行
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
