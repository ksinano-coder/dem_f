import sys
import os
import uuid
from decimal import Decimal

from PyQt5.QtCore import Qt, QDate
from PyQt5.QtGui import QColor, QFont, QIcon, QPixmap
from PyQt5.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
                             QLabel, QLineEdit, QPushButton, QComboBox, QTableWidget,
                             QTableWidgetItem, QMessageBox, QDialog, QFormLayout, QFileDialog,
                             QDateEdit, QHeaderView)

from db import get_connection

COLOR_MAIN = "#FFFFFF"  # основной цвет
COLOR_SECOND = "#DAA520"  # доп цвет
COLOR_ACCENT = "#B8860B"  # цвет акцента
COLOR_DISCOUNT = "#F4A460"  # крашу если скидка больше 12
COLOR_ZERO_STOCK = "#ADD8E6"  # крашу в голубой если нет остатка

# настраиваю пути чтобы exe работал
def get_base_dir():
    # если запускаю из exe
    if getattr(sys, 'frozen', False):
        return sys._MEIPASS
    # если запускаю из pycharm
    else:
        return os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

BASE_DIR = get_base_dir()
PHOTOS_DIR = os.path.join(BASE_DIR, "resources", "photos")
PICTURE_PNG = os.path.join(BASE_DIR, "resources", "picture.png")

# мое окно авторизации

class LoginDialog(QDialog):
    def __init__(self):
        super().__init__()
        self.user_data = None
        self.setWindowTitle("ООО «СтройМатериалы» - Вход")
        self.setWindowIcon(QIcon(os.path.join(BASE_DIR, "resources", "Icon.ico")))
        self.setStyleSheet(f"background-color: {COLOR_MAIN};")
        self.setMinimumWidth(350)

        layout = QFormLayout(self)
        self.login_edit = QLineEdit()
        self.password_edit = QLineEdit()
        # прячем пароль за звездочками
        self.password_edit.setEchoMode(QLineEdit.Password)

        layout.addRow("Логин:", self.login_edit)
        layout.addRow("Пароль:", self.password_edit)

        btn_layout = QHBoxLayout()
        btn_login = QPushButton("Войти")
        btn_login.setStyleSheet(f"background-color: {COLOR_ACCENT}; color: white; padding: 5px;")
        btn_login.clicked.connect(self.auth)

        btn_guest = QPushButton("Войти как гость")
        btn_guest.setStyleSheet(f"background-color: {COLOR_SECOND}; color: white; padding: 5px;")
        btn_guest.clicked.connect(self.guest_auth)

        btn_layout.addWidget(btn_login)
        btn_layout.addWidget(btn_guest)
        layout.addRow(btn_layout)

    def auth(self):
        # ищем пользователя в базе
        login = self.login_edit.text()
        password = self.password_edit.text()
        try:
            conn = get_connection()
            cur = conn.cursor(dictionary=True)
            cur.execute(
                "SELECT u.full_name, r.role_name FROM users u JOIN roles r ON r.role_id = u.role_id WHERE u.login = %s AND u.password_plain = %s",
                (login, password))
            user = cur.fetchone()
            conn.close()

            if user:
                self.user_data = user
                self.accept()
            else:
                QMessageBox.critical(self, "Ошибка", "Неверный логин или пароль")
        except Exception as e:
            QMessageBox.critical(self, "Ошибка БД", str(e))

    def guest_auth(self):
        # даем гостю пустые данные
        self.user_data = {"full_name": "Гость", "role_name": "Гость"}
        self.accept()

# форма для работы с товаром
class ProductFormDialog(QDialog):
    def __init__(self, product_id=None):
        super().__init__()
        self.product_id = product_id
        self.old_photo_file = ""
        self.selected_photo_path = ""

        title = "Редактирование товара" if product_id else "Добавление товара"
        self.setWindowTitle(title)
        self.setStyleSheet(f"background-color: {COLOR_MAIN};")
        self.setMinimumWidth(600)

        layout = QVBoxLayout(self)
        form = QFormLayout()

        self.id_edit = QLineEdit()
        # id менять нельзя
        self.id_edit.setReadOnly(True)
        self.article_edit = QLineEdit()
        self.name_edit = QLineEdit()
        self.price_edit = QLineEdit()
        self.stock_edit = QLineEdit()
        self.discount_edit = QLineEdit()

        if self.product_id:
            form.addRow("ID товара:", self.id_edit)
        form.addRow("Артикул:", self.article_edit)
        form.addRow("Название:", self.name_edit)
        form.addRow("Цена:", self.price_edit)
        form.addRow("Остаток:", self.stock_edit)
        form.addRow("Скидка (%):", self.discount_edit)

        photo_layout = QHBoxLayout()
        self.photo_label = QLabel("Нет фото")
        self.photo_label.setFixedSize(300, 200)
        self.photo_label.setStyleSheet("border: 1px solid gray;")
        self.photo_label.setAlignment(Qt.AlignCenter)

        btn_photo = QPushButton("Выбрать фото")
        btn_photo.setStyleSheet(f"background-color: {COLOR_SECOND}; color: white;")
        btn_photo.clicked.connect(self.choose_photo)

        photo_layout.addWidget(self.photo_label)
        photo_layout.addWidget(btn_photo)
        form.addRow("Фотография:", photo_layout)

        layout.addLayout(form)

        btn_save = QPushButton("Сохранить")
        btn_save.setStyleSheet(f"background-color: {COLOR_ACCENT}; color: white; padding: 8px;")
        btn_save.clicked.connect(self.save_data)
        layout.addWidget(btn_save)

        if self.product_id:
            self.load_product()

    def load_product(self):
        # вытаскиваем инфу о товаре
        conn = get_connection()
        cur = conn.cursor(dictionary=True)
        cur.execute("SELECT * FROM products WHERE product_id = %s", (self.product_id,))
        row = cur.fetchone()
        conn.close()

        if row:
            self.id_edit.setText(str(row['product_id']))
            self.article_edit.setText(row['article'])
            self.name_edit.setText(row['name'])
            self.price_edit.setText(str(row['price']))
            self.stock_edit.setText(str(row['stock_quantity']))
            self.discount_edit.setText(str(row['discount_percent']))

            if row['photo_file']:
                self.old_photo_file = row['photo_file']
                path = os.path.join(BASE_DIR, row['photo_file'])
                if os.path.exists(path):
                    self.set_preview(path)

    def set_preview(self, file_path):
        pix = QPixmap(file_path)
        if not pix.isNull():
            self.photo_label.setPixmap(pix.scaled(300, 200, Qt.IgnoreAspectRatio, Qt.SmoothTransformation))

    def choose_photo(self):
        # открываем окно выбора картинки
        path, _ = QFileDialog.getOpenFileName(self, "Выберите фото", "", "Images (*.png *.jpg *.jpeg)")
        if not path: return
        self.selected_photo_path = path
        self.set_preview(path)

    def save_data(self):
        # защита от отрицательного
        try:
            price = Decimal(self.price_edit.text().replace(',', '.'))
            stock = int(self.stock_edit.text())
            discount = Decimal(self.discount_edit.text().replace(',', '.'))
            if price < 0 or stock < 0 or discount < 0:
                raise ValueError
        except:
            QMessageBox.warning(self, "Ошибка", "Цена, остаток и скидка должны быть положительными числами!")
            return

        photo_db_path = self.old_photo_file
        if self.selected_photo_path:
            os.makedirs(PHOTOS_DIR, exist_ok=True)
            ext = os.path.splitext(self.selected_photo_path)[1]
            new_filename = f"uploaded_{uuid.uuid4().hex}{ext}"
            target_path = os.path.join(PHOTOS_DIR, new_filename)

            # автоматически сжимаем фото до 300х200
            pix = QPixmap(self.selected_photo_path)
            scaled_pix = pix.scaled(300, 200, Qt.IgnoreAspectRatio, Qt.SmoothTransformation)
            scaled_pix.save(target_path)

            photo_db_path = f"resources/photos/{new_filename}"
            # удаляю старую картинку
            if self.old_photo_file:
                old_path = os.path.join(BASE_DIR, self.old_photo_file)
                if os.path.exists(old_path):
                    try:
                        os.remove(old_path)
                    except:
                        pass
        # пишу в бд
        conn = get_connection()
        cur = conn.cursor()
        if self.product_id:
            cur.execute("""UPDATE products SET article=%s, name=%s, price=%s, stock_quantity=%s, discount_percent=%s, photo_file=%s 
                           WHERE product_id=%s""",
                        (self.article_edit.text(), self.name_edit.text(), price, stock, discount, photo_db_path,
                         self.product_id))
        else:
            cur.execute("""INSERT INTO products (article, name, unit_name, price, supplier_id, manufacturer_id, category_id, discount_percent, stock_quantity, photo_file) 
                           VALUES (%s, %s, 'шт', %s, 1, 1, 1, %s, %s, %s)""",
                        (self.article_edit.text(), self.name_edit.text(), price, discount, stock, photo_db_path))
        conn.commit()
        conn.close()
        self.accept()

# форма для работы с заказами
class OrderFormDialog(QDialog):
    def __init__(self, order_id=None):
        super().__init__()
        self.order_id = order_id
        self.setWindowTitle("Редактирование заказа" if order_id else "Добавление заказа")
        self.setStyleSheet(f"background-color: {COLOR_MAIN};")
        self.setMinimumWidth(500)

        layout = QVBoxLayout(self)
        form = QFormLayout()

        self.article_edit = QLineEdit()
        self.status_combo = QComboBox()
        self.pickup_combo = QComboBox()
        self.order_date_edit = QDateEdit()
        self.order_date_edit.setCalendarPopup(True)
        self.delivery_date_edit = QDateEdit()
        self.delivery_date_edit.setCalendarPopup(True)

        self.status_dict = {}
        self.pickup_dict = {}
        self.load_dictionaries()

        form.addRow("Артикул(ы):", self.article_edit)
        form.addRow("Статус заказа:", self.status_combo)
        form.addRow("Пункт выдачи:", self.pickup_combo)
        form.addRow("Дата заказа:", self.order_date_edit)
        form.addRow("Дата доставки:", self.delivery_date_edit)

        layout.addLayout(form)

        btn_save = QPushButton("Сохранить")
        btn_save.setStyleSheet(f"background-color: {COLOR_ACCENT}; color: white; padding: 8px;")
        btn_save.clicked.connect(self.save_data)
        layout.addWidget(btn_save)

        if self.order_id:
            self.load_order()
        else:
            self.order_date_edit.setDate(QDate.currentDate())
            self.delivery_date_edit.setDate(QDate.currentDate().addDays(3))

    def load_dictionaries(self):
        # подгружаем выпадающие списки
        conn = get_connection()
        cur = conn.cursor(dictionary=True)

        cur.execute("SELECT status_id, status_name FROM order_statuses")
        for row in cur.fetchall():
            self.status_dict[row['status_name']] = row['status_id']
            self.status_combo.addItem(row['status_name'])

        cur.execute("SELECT pickup_point_id, address_text FROM pickup_points")
        for row in cur.fetchall():
            self.pickup_dict[row['address_text']] = row['pickup_point_id']
            self.pickup_combo.addItem(row['address_text'])

        conn.close()

    def load_order(self):
        # берем данные заказа
        conn = get_connection()
        cur = conn.cursor(dictionary=True)
        cur.execute("""SELECT o.article_text, o.order_date, o.delivery_date, 
                              s.status_name, p.address_text 
                       FROM orders o
                       JOIN order_statuses s ON o.status_id = s.status_id
                       JOIN pickup_points p ON o.pickup_point_id = p.pickup_point_id
                       WHERE o.order_id = %s""", (self.order_id,))
        row = cur.fetchone()
        conn.close()

        if row:
            self.article_edit.setText(row['article_text'])
            self.status_combo.setCurrentText(row['status_name'])
            self.pickup_combo.setCurrentText(row['address_text'])
            if row['order_date']:
                self.order_date_edit.setDate(row['order_date'])
            if row['delivery_date']:
                self.delivery_date_edit.setDate(row['delivery_date'])

    def save_data(self):
        status_id = self.status_dict[self.status_combo.currentText()]
        pickup_id = self.pickup_dict[self.pickup_combo.currentText()]
        o_date = self.order_date_edit.date().toPyDate()
        d_date = self.delivery_date_edit.date().toPyDate()

        # проверка чтобы даты не конфликтовали
        if d_date < o_date:
            QMessageBox.warning(self, "Ошибка", "Дата доставки не может быть раньше даты заказа!")
            return

        conn = get_connection()
        cur = conn.cursor(dictionary=True)

        if self.order_id:
            cur.execute("""UPDATE orders SET article_text=%s, status_id=%s, pickup_point_id=%s, 
                           order_date=%s, delivery_date=%s WHERE order_id=%s""",
                        (self.article_edit.text(), status_id, pickup_id, o_date, d_date, self.order_id))
        else:
            cur.execute("SELECT COALESCE(MAX(order_number), 0) + 1 as next_num FROM orders")
            next_num = cur.fetchone()['next_num']

            cur.execute("""INSERT INTO orders (order_number, article_text, order_date, delivery_date, pickup_point_id, status_id) 
                           VALUES (%s, %s, %s, %s, %s, %s)""",
                        (next_num, self.article_edit.text(), o_date, d_date, pickup_id, status_id))
        conn.commit()
        conn.close()
        self.accept()

# окно списка заказов

class OrdersWindow(QMainWindow):
    def __init__(self, user_data, main_window=None):
        super().__init__()
        self.user_data = user_data
        self.main_window = main_window

        self.setWindowTitle("ООО «СтройМатериалы» - Список заказов")
        self.setWindowIcon(QIcon(os.path.join(BASE_DIR, "resources", "Icon.ico")))
        self.resize(1000, 600)
        self.setStyleSheet(f"background-color: {COLOR_MAIN};")

        main_widget = QWidget()
        self.setCentralWidget(main_widget)
        layout = QVBoxLayout(main_widget)

        btn_layout = QHBoxLayout()
        # делаем кнопку назад
        btn_back = QPushButton("Назад")
        btn_back.setStyleSheet(f"background-color: {COLOR_SECOND}; color: white; padding: 5px;")
        btn_back.clicked.connect(self.go_back)
        btn_layout.addWidget(btn_back)

        if self.user_data['role_name'] == "Администратор":
            btn_add = QPushButton("Добавить заказ")
            btn_add.setStyleSheet(f"background-color: {COLOR_ACCENT}; color: white; padding: 5px;")
            btn_add.clicked.connect(self.add_order)

            btn_del = QPushButton("Удалить заказ")
            btn_del.setStyleSheet(f"background-color: red; color: white; padding: 5px;")
            btn_del.clicked.connect(self.delete_order)

            btn_layout.addWidget(btn_add)
            btn_layout.addWidget(btn_del)

        btn_layout.addStretch()
        layout.addLayout(btn_layout)

        self.table = QTableWidget()
        self.table.setColumnCount(6)
        self.table.setHorizontalHeaderLabels(
            ["ID", "Артикул заказа", "Статус заказа", "Адрес пункта выдачи", "Дата заказа", "Дата доставки"])
        self.table.setColumnHidden(0, True)
        self.table.setSelectionBehavior(QTableWidget.SelectRows)
        self.table.setEditTriggers(QTableWidget.NoEditTriggers)
        self.table.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)

        if self.user_data['role_name'] == "Администратор":
            self.table.itemDoubleClicked.connect(self.edit_order)

        layout.addWidget(self.table)
        self.load_data()

    def go_back(self):
        self.close()
        if self.main_window:
            self.main_window.show()

    def closeEvent(self, event):
        if self.main_window:
            self.main_window.show()
        event.accept()

    def load_data(self):
        conn = get_connection()
        cur = conn.cursor(dictionary=True)
        cur.execute("""SELECT o.order_id, o.article_text, s.status_name, p.address_text, 
                              o.order_date, o.delivery_date
                       FROM orders o
                       JOIN order_statuses s ON o.status_id = s.status_id
                       JOIN pickup_points p ON o.pickup_point_id = p.pickup_point_id""")
        rows = cur.fetchall()
        conn.close()

        self.table.setRowCount(len(rows))
        for i, row in enumerate(rows):
            o_date = row['order_date'].strftime('%d.%m.%Y') if row['order_date'] else ""
            d_date = row['delivery_date'].strftime('%d.%m.%Y') if row['delivery_date'] else ""

            self.table.setItem(i, 0, QTableWidgetItem(str(row['order_id'])))
            self.table.setItem(i, 1, QTableWidgetItem(row['article_text']))
            self.table.setItem(i, 2, QTableWidgetItem(row['status_name']))
            self.table.setItem(i, 3, QTableWidgetItem(row['address_text']))
            self.table.setItem(i, 4, QTableWidgetItem(o_date))
            self.table.setItem(i, 5, QTableWidgetItem(d_date))

            for col in range(1, 6):
                self.table.item(i, col).setTextAlignment(Qt.AlignCenter)

    def get_selected_id(self):
        # вытягиваем id из строки
        row = self.table.currentRow()
        if row < 0: return None
        return int(self.table.item(row, 0).text())

    def add_order(self):
        dlg = OrderFormDialog()
        if dlg.exec_():
            self.load_data()

    def edit_order(self):
        o_id = self.get_selected_id()
        if not o_id: return
        dlg = OrderFormDialog(o_id)
        if dlg.exec_():
            self.load_data()

    def delete_order(self):
        o_id = self.get_selected_id()
        if not o_id:
            QMessageBox.warning(self, "Внимание", "Выберите заказ для удаления!")
            return
        # спрашиваем перед удалением
        reply = QMessageBox.question(self, "Подтверждение", "Удалить выбранный заказ?",
                                     QMessageBox.Yes | QMessageBox.No)
        if reply == QMessageBox.Yes:
            conn = get_connection()
            cur = conn.cursor()
            cur.execute("DELETE FROM orders WHERE order_id = %s", (o_id,))
            conn.commit()
            conn.close()
            self.load_data()

# главное окно программы

class MainWindow(QMainWindow):
    def __init__(self, user_data):
        super().__init__()
        self.user_data = user_data
        self.setWindowTitle("ООО «СтройМатериалы» - Список товаров")
        self.setWindowIcon(QIcon(os.path.join(BASE_DIR, "resources", "Icon.ico")))
        self.resize(1300, 750)
        self.setStyleSheet(f"background-color: {COLOR_MAIN};")

        main_widget = QWidget()
        self.setCentralWidget(main_widget)
        layout = QVBoxLayout(main_widget)

        # шапка с логотипом
        header = QHBoxLayout()

        logo_label = QLabel()
        logo_path = os.path.join(BASE_DIR, "resources", "logo.png")
        if os.path.exists(logo_path):
            logo_pix = QPixmap(logo_path).scaled(50, 50, Qt.KeepAspectRatio, Qt.SmoothTransformation)
            logo_label.setPixmap(logo_pix)

        header.addWidget(logo_label)
        header.addWidget(QLabel(f"Пользователь: {self.user_data['full_name']} | Роль: {self.user_data['role_name']}"))

        # кнопка перехода к заказам
        if self.user_data['role_name'] in ["Менеджер", "Администратор"]:
            btn_orders = QPushButton("Заказы")
            btn_orders.setStyleSheet(f"background-color: {COLOR_SECOND}; padding: 5px;")
            btn_orders.clicked.connect(self.open_orders)
            header.addWidget(btn_orders)

        header.addStretch()

        if self.user_data['role_name'] == "Администратор":
            btn_add = QPushButton("Добавить товар")
            btn_add.setStyleSheet(f"background-color: {COLOR_ACCENT}; color: white;")
            btn_add.clicked.connect(self.add_product)

            btn_edit = QPushButton("Редактировать")
            btn_edit.setStyleSheet(f"background-color: {COLOR_SECOND}; color: white;")
            btn_edit.clicked.connect(self.edit_product)

            btn_del = QPushButton("Удалить")
            btn_del.setStyleSheet(f"background-color: red; color: white;")
            btn_del.clicked.connect(self.delete_product)

            header.addWidget(btn_add)
            header.addWidget(btn_edit)
            header.addWidget(btn_del)

        layout.addLayout(header)

        # делаем фильтры и поиск
        if self.user_data['role_name'] in ["Менеджер", "Администратор"]:
            filter_layout = QHBoxLayout()
            self.search_input = QLineEdit()
            self.search_input.setPlaceholderText("Поиск...")
            self.search_input.textChanged.connect(self.load_data)

            self.sort_combo = QComboBox()
            self.sort_combo.addItems(["Без сортировки", "Остаток (возр)", "Остаток (убыв)",
                                      "Цена (возр)", "Цена (убыв)", "Скидка (возр)", "Скидка (убыв)"])
            self.sort_combo.currentTextChanged.connect(self.load_data)

            self.manufacturer_combo = QComboBox()
            self.manufacturer_combo.addItem("Все производители")
            self.load_manufacturers()
            self.manufacturer_combo.currentTextChanged.connect(self.load_data)

            filter_layout.addWidget(QLabel("Поиск:"))
            filter_layout.addWidget(self.search_input)
            filter_layout.addWidget(QLabel("Производитель:"))
            filter_layout.addWidget(self.manufacturer_combo)
            filter_layout.addWidget(QLabel("Сортировка:"))
            filter_layout.addWidget(self.sort_combo)
            layout.addLayout(filter_layout)

        # выводим таблицу на экран
        self.table = QTableWidget()
        self.table.setColumnCount(13)
        self.table.setHorizontalHeaderLabels(
            ["ID", "Фото", "Артикул", "Название", "Категория", "Описание",
             "Производитель", "Поставщик", "Цена", "Цена со скидкой", "Ед.", "Остаток", "Скидка %"]
        )
        self.table.setColumnHidden(0, True)
        self.table.setSelectionBehavior(QTableWidget.SelectRows)
        self.table.setEditTriggers(QTableWidget.NoEditTriggers)

        self.table.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
        self.table.horizontalHeader().setSectionResizeMode(1, QHeaderView.ResizeToContents)
        self.table.horizontalHeader().setSectionResizeMode(2, QHeaderView.ResizeToContents)

        layout.addWidget(self.table)

        self.load_data()

    def load_manufacturers(self):
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("SELECT name FROM manufacturers")
        for row in cur.fetchall():
            self.manufacturer_combo.addItem(row[0])
        conn.close()

    def open_orders(self):
        self.hide()
        self.orders_window = OrdersWindow(self.user_data, main_window=self)
        self.orders_window.show()

    def load_data(self):
        conn = get_connection()
        cur = conn.cursor(dictionary=True)
        cur.execute("""SELECT p.product_id, p.photo_file, p.article, p.name, c.name as cat, 
                       p.description_text, m.name as man, s.name as sup, p.price, 
                       p.discount_percent, p.unit_name, p.stock_quantity
                       FROM products p
                       JOIN categories c ON p.category_id = c.category_id
                       JOIN manufacturers m ON p.manufacturer_id = m.manufacturer_id
                       JOIN suppliers s ON p.supplier_id = s.supplier_id""")
        rows = cur.fetchall()
        conn.close()

        if hasattr(self, 'search_input'):
            search_txt = self.search_input.text().lower()
            sort_val = self.sort_combo.currentText()
            man_val = self.manufacturer_combo.currentText()

            if man_val != "Все производители":
                rows = [r for r in rows if r['man'] == man_val]

            if search_txt:
                rows = [r for r in rows if search_txt in str(r).lower()]

            if "Остаток (возр)" in sort_val:
                rows.sort(key=lambda x: x['stock_quantity'])
            elif "Остаток (убыв)" in sort_val:
                rows.sort(key=lambda x: x['stock_quantity'], reverse=True)
            elif "Цена (возр)" in sort_val:
                rows.sort(key=lambda x: x['price'])
            elif "Цена (убыв)" in sort_val:
                rows.sort(key=lambda x: x['price'], reverse=True)
            elif "Скидка (возр)" in sort_val:
                rows.sort(key=lambda x: x['discount_percent'])
            elif "Скидка (убыв)" in sort_val:
                rows.sort(key=lambda x: x['discount_percent'], reverse=True)

        self.table.setRowCount(len(rows))
        for i, row in enumerate(rows):
            # считаем цену со скидкой
            price = Decimal(row['price'])
            discount = Decimal(row['discount_percent'])
            final_price = price - (price * discount / Decimal(100))

            img_path = os.path.join(PHOTOS_DIR, os.path.basename(row['photo_file'])) if row[
                'photo_file'] else PICTURE_PNG
            if not os.path.exists(img_path): img_path = PICTURE_PNG

            img_label = QLabel()
            pix = QPixmap(img_path).scaled(100, 70, Qt.KeepAspectRatio, Qt.SmoothTransformation)
            img_label.setPixmap(pix)
            img_label.setAlignment(Qt.AlignCenter)
            self.table.setCellWidget(i, 1, img_label)

            items = [
                QTableWidgetItem(str(row['product_id'])), QTableWidgetItem(""),
                QTableWidgetItem(row['article']), QTableWidgetItem(row['name']),
                QTableWidgetItem(row['cat']), QTableWidgetItem(str(row['description_text'] or "")),
                QTableWidgetItem(row['man']), QTableWidgetItem(row['sup']),
                QTableWidgetItem(f"{price:.2f}"), QTableWidgetItem(f"{final_price:.2f}"),
                QTableWidgetItem(row['unit_name']), QTableWidgetItem(str(row['stock_quantity'])),
                QTableWidgetItem(f"{discount:.2f}")
            ]

            for col, item in enumerate(items):
                if col == 1: continue

                if row['stock_quantity'] == 0:
                    item.setBackground(QColor(COLOR_ZERO_STOCK))
                elif discount > 12:
                    item.setBackground(QColor(COLOR_DISCOUNT))

                if discount > 0 and col == 8:
                    font = item.font()
                    font.setStrikeOut(True)
                    item.setFont(font)
                    item.setForeground(QColor("red"))

                if col not in [3, 5]:
                    item.setTextAlignment(Qt.AlignCenter)

                self.table.setItem(i, col, item)

        self.table.resizeRowsToContents()

    def get_selected_id(self):
        row = self.table.currentRow()
        if row < 0: return None
        return int(self.table.item(row, 0).text())

    def add_product(self):
        dlg = ProductFormDialog()
        if dlg.exec_():
            self.load_data()

    def edit_product(self):
        prod_id = self.get_selected_id()
        if not prod_id:
            QMessageBox.warning(self, "Внимание", "Выберите товар для редактирования!")
            return
        dlg = ProductFormDialog(prod_id)
        if dlg.exec_():
            self.load_data()

    def delete_product(self):
        prod_id = self.get_selected_id()
        if not prod_id:
            QMessageBox.warning(self, "Внимание", "Выберите товар для удаления!")
            return
        # не даем удалить если товар уже в заказе
        conn = get_connection()
        cur = conn.cursor(dictionary=True)
        cur.execute("SELECT COUNT(*) as c FROM order_items WHERE product_id = %s", (prod_id,))
        count = cur.fetchone()['c']

        if count > 0:
            QMessageBox.warning(self, "Запрещено", "Этот товар присутствует в заказах. Удаление невозможно!")
            conn.close()
            return

        reply = QMessageBox.question(self, "Подтверждение", "Удалить выбранный товар?",
                                     QMessageBox.Yes | QMessageBox.No)
        if reply == QMessageBox.Yes:
            cur.execute("DELETE FROM products WHERE product_id = %s", (prod_id,))
            conn.commit()
            conn.close()
            self.load_data()

if __name__ == "__main__":
    app = QApplication(sys.argv)

    font = QFont("Calibri", 11)
    app.setFont(font)

    login_dialog = LoginDialog()
    if login_dialog.exec_():
        window = MainWindow(login_dialog.user_data)
        window.show()
        sys.exit(app.exec_())