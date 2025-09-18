#!/bin/bash

# Скрипт запуска Hugo сервера в режиме разработки
# Использует hugo.local.toml конфигурацию без аналитики

echo "🚀 Запуск Hugo сервера в режиме разработки..."

# Проверяем, не запущен ли уже сервер
if lsof -Pi :1313 -sTCP:LISTEN -t >/dev/null ; then
    echo "⚠️  Порт 1313 уже занят! Возможно, сервер уже запущен."
    echo "💡 Используйте ./stop-dev.sh для остановки"
    exit 1
fi

echo "📝 Конфигурация: hugo.local.toml"
echo "🌐 Сервер будет доступен по адресу: http://localhost:1313"
echo ""

# Запуск Hugo сервера в фоновом режиме
hugo server --config hugo.local.toml --bind 0.0.0.0 --port 1313 --buildDrafts --buildFuture --disableFastRender > hugo-dev.log 2>&1 &

# Получаем PID процесса
HUGO_PID=$!

# Ждем немного, чтобы сервер успел запуститься
sleep 2

# Проверяем, что процесс запустился успешно
if kill -0 $HUGO_PID 2>/dev/null; then
    echo "✅ Hugo сервер успешно запущен в фоновом режиме (PID: $HUGO_PID)"
    echo "📋 Логи сохраняются в файл: hugo-dev.log"
    echo "🛑 Для остановки используйте: ./stop-dev.sh"
    echo ""
    echo "🎉 Управление возвращено в консоль. Сервер работает в фоне."
else
    echo "❌ Ошибка запуска сервера! Проверьте логи в файле hugo-dev.log"
    exit 1
fi
