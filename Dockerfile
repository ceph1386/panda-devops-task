# Використовуємо Alpine образ
FROM nginx:1.27-alpine

# Копіюємо кастомний конфіг Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Копіюємо статичні файли веб-додатку
COPY html/ /usr/share/nginx/html/

# Відкриваємо 80-й порт
EXPOSE 80

# Додаємо періодичний healthcheck (кожні 30 секунд перевіряємо працездатність)
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -q --spider http://127.0.0.1/health || exit 1

# Запуск Nginx у foreground режимі
CMD ["nginx", "-g", "daemon off;"]
