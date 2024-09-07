# Use the official PHP image as base
FROM php:8.3-fpm

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    nginx \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql zip

# Install GD extension
RUN apt-get install -y libwebp-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd

# Copy project files
COPY . .

# Configure Nginx
COPY ./docker-nginx.conf /etc/nginx/conf.d/default.conf

# Grant write permissions for all users
RUN chmod -R 777 storage resources bootstrap/cache

# Expose port 80 for the web server
EXPOSE 80

# Start Nginx and PHP-FPM
CMD ["sh", "-c", "service nginx start && php-fpm"]
