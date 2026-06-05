import mysql.connector

DB_CONFIG = {
    "host": "127.0.0.1",
    "port": 3306,
    "user": "root",  # Стандартный логин в XAMPP
    "password": "",  # В XAMPP пароль по умолчанию пустой
    "database": "dem_bd",
    "use_unicode": True,
    "charset": "utf8mb4",
    "use_pure": True,
}

def get_connection():
    return mysql.connector.connect(**DB_CONFIG)