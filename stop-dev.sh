#!/bin/bash

# Скрипт остановки Hugo сервера и освобождения ресурсов
# Находит и завершает все процессы Hugo, освобождает порт 1313

echo "🛑 Остановка Hugo сервера..."

# Поиск и завершение процессов Hugo
HUGO_PIDS=$(pgrep -f "hugo server")

if [ -n "$HUGO_PIDS" ]; then
    echo "📋 Найдены процессы Hugo: $HUGO_PIDS"
    
    # Мягкое завершение процессов
    echo "🔄 Завершение процессов Hugo..."
    kill $HUGO_PIDS 2>/dev/null
    
    # Ждем 3 секунды для корректного завершения
    sleep 3
    
    # Проверяем, завершились ли процессы
    REMAINING_PIDS=$(pgrep -f "hugo server")
    
    if [ -n "$REMAINING_PIDS" ]; then
        echo "⚠️  Принудительное завершение оставшихся процессов..."
        kill -9 $REMAINING_PIDS 2>/dev/null
    fi
    
    echo "✅ Процессы Hugo завершены"
else
    echo "ℹ️  Активные процессы Hugo не найдены"
fi

# Проверка и освобождение порта 1313
echo "🔍 Проверка порта 1313..."
PORT_PID=$(lsof -ti:1313)

if [ -n "$PORT_PID" ]; then
    echo "📋 Порт 1313 занят процессом: $PORT_PID"
    echo "🔄 Освобождение порта 1313..."
    kill -9 $PORT_PID 2>/dev/null
    echo "✅ Порт 1313 освобожден"
else
    echo "ℹ️  Порт 1313 свободен"
fi

# Очистка временных файлов Hugo
echo "🧹 Очистка временных файлов..."
if [ -d "resources/_gen" ]; then
    rm -rf resources/_gen
    echo "✅ Временные файлы удалены"
fi

# Удаление лог-файла
if [ -f "hugo-dev.log" ]; then
    rm hugo-dev.log
    echo "✅ Лог-файл удален"
fi

echo ""
echo "🎉 Hugo сервер полностью остановлен и ресурсы освобождены!"
echo "💡 Для запуска используйте: ./start-dev.sh"
