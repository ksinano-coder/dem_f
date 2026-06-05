-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Июн 06 2026 г., 08:28
-- Версия сервера: 8.0.30
-- Версия PHP: 8.0.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `dem_bd`
--

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

CREATE TABLE `categories` (
  `category_id` int UNSIGNED NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `categories`
--

INSERT INTO `categories` (`category_id`, `name`) VALUES
(5, 'Защита лица, глаз, головы'),
(1, 'Общестроительные материалы'),
(4, 'Ручной инструмент'),
(2, 'Стеновые и фасадные материалы'),
(3, 'Сухие строительные смеси и гидроизоляция');

-- --------------------------------------------------------

--
-- Структура таблицы `manufacturers`
--

CREATE TABLE `manufacturers` (
  `manufacturer_id` int UNSIGNED NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `manufacturers`
--

INSERT INTO `manufacturers` (`manufacturer_id`, `name`) VALUES
(11, 'Armero'),
(17, 'Delta'),
(10, 'Hesler'),
(16, 'Husqvarna'),
(13, 'KILIMGRIN'),
(3, 'Knauf'),
(4, 'MixMaster'),
(15, 'RUIZ'),
(7, 'Vinylon'),
(9, 'Weber'),
(12, 'Wenzo Roma'),
(6, 'ВОЛМА'),
(2, 'Изостронг'),
(14, 'Исток'),
(5, 'ЛСР'),
(1, 'М500'),
(8, 'Павловский завод');

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `order_id` int UNSIGNED NOT NULL,
  `order_number` int UNSIGNED NOT NULL,
  `article_text` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `order_date` date DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `pickup_point_id` int UNSIGNED NOT NULL,
  `status_id` tinyint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `orders`
--

INSERT INTO `orders` (`order_id`, `order_number`, `article_text`, `order_date`, `delivery_date`, `pickup_point_id`, `status_id`) VALUES
(1, 1, 'PMEZMH, 2, BPV4MM, 2', '2025-02-27', '2025-04-20', 1, 1),
(2, 2, 'JVL42J, 1, F895RB, 1', '2024-09-28', '2025-04-21', 11, 1),
(3, 3, '3XBOTN, 10, 3L7RCZ, 10', '2025-03-21', '2025-04-22', 2, 1),
(4, 4, 'S72AM3, 5, 2G3280, 4', '2025-02-20', '2025-04-23', 11, 1),
(5, 5, 'MIO8YV, 2, UER2QD, 2', '2025-03-17', '2025-04-24', 2, 1),
(6, 6, 'ZR70B4, 1, LPDDM4, 1', '2025-03-01', '2025-04-25', 15, 1),
(7, 7, 'LQ48MW, 10, O43COU8, 10', '0000-00-00', '2025-04-26', 3, 1),
(8, 8, 'M26EXW, 5, K0YACK, 4', '2025-03-31', '2025-04-27', 19, 2),
(9, 9, 'ASPXSG, 5, ZKQ5FF, 1', '2025-04-02', '2025-04-28', 5, 2),
(10, 10, '4WZEOT, 5, 4JR1HN, 5', '2025-04-03', '2025-04-29', 19, 2);

-- --------------------------------------------------------

--
-- Структура таблицы `orders_import_raw`
--

CREATE TABLE `orders_import_raw` (
  `raw_id` int UNSIGNED NOT NULL,
  `order_number_text` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `articles_text` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `order_date_text` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `delivery_date_text` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pickup_point_text` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `client_fio_text` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pickup_code_text` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_text` varchar(80) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `orders_import_raw`
--

INSERT INTO `orders_import_raw` (`raw_id`, `order_number_text`, `articles_text`, `order_date_text`, `delivery_date_text`, `pickup_point_text`, `client_fio_text`, `pickup_code_text`, `status_text`) VALUES
(1, '1', 'PMEZMH, 2, BPV4MM, 2', '27.02.2025', '20.04.2025', '1', 'Михайлюк Анна Вячеславовна', '901', 'Завершен'),
(2, '2', 'JVL42J, 1, F895RB, 1', '28.09.2024', '21.04.2025', '11', 'Ситдикова Елена Анатольевна', '902', 'Завершен'),
(3, '3', '3XBOTN, 10, 3L7RCZ, 10', '21.03.2025', '22.04.2025', '2', 'Никифорова Весения Николаевна', '903', 'Завершен'),
(4, '4', 'S72AM3, 5, 2G3280, 4', '20.02.2025', '23.04.2025', '11', 'Сазонов Руслан Германович', '904', 'Завершен'),
(5, '5', 'MIO8YV, 2, UER2QD, 2', '17.03.2025', '24.04.2025', '2', 'Михайлюк Анна Вячеславовна', '905', 'Завершен'),
(6, '6', 'ZR70B4, 1, LPDDM4, 1', '01.03.2025', '25.04.2025', '15', 'Ситдикова Елена Анатольевна', '906', 'Завершен'),
(7, '7', 'LQ48MW, 10, O43COU8, 10', '30.02.2025', '26.04.2025', '3', 'Никифорова Весения Николаевна', '907', 'Завершен'),
(8, '8', 'M26EXW, 5, K0YACK, 4', '31.03.2025', '27.04.2025', '19', 'Сазонов Руслан Германович', '908', 'Новый'),
(9, '9', 'ASPXSG, 5, ZKQ5FF, 1', '02.04.2025', '28.04.2025', '5', 'Никифорова Весения Николаевна', '909', 'Новый'),
(10, '10', '4WZEOT, 5, 4JR1HN, 5', '03.04.2025', '29.04.2025', '19', 'Сазонов Руслан Германович', '910', 'Новый');

-- --------------------------------------------------------

--
-- Структура таблицы `order_items`
--

CREATE TABLE `order_items` (
  `order_item_id` int UNSIGNED NOT NULL,
  `order_id` int UNSIGNED NOT NULL,
  `product_id` int UNSIGNED NOT NULL,
  `quantity` int NOT NULL
) ;

--
-- Дамп данных таблицы `order_items`
--

INSERT INTO `order_items` (`order_item_id`, `order_id`, `product_id`, `quantity`) VALUES
(1, 1, 1, 2),
(2, 2, 3, 1),
(3, 3, 5, 10),
(4, 4, 7, 5),
(5, 5, 9, 2),
(6, 6, 11, 1),
(7, 7, 13, 10),
(8, 8, 15, 5),
(9, 9, 17, 5),
(10, 10, 19, 5),
(11, 1, 2, 2),
(12, 2, 4, 1),
(13, 3, 6, 10),
(14, 4, 8, 4),
(15, 5, 10, 2),
(16, 6, 12, 1),
(17, 8, 16, 4),
(18, 9, 18, 1),
(19, 10, 20, 5);

-- --------------------------------------------------------

--
-- Структура таблицы `order_statuses`
--

CREATE TABLE `order_statuses` (
  `status_id` tinyint UNSIGNED NOT NULL,
  `status_name` varchar(60) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `order_statuses`
--

INSERT INTO `order_statuses` (`status_id`, `status_name`) VALUES
(1, 'Завершен'),
(2, 'Новый');

-- --------------------------------------------------------

--
-- Структура таблицы `pickup_points`
--

CREATE TABLE `pickup_points` (
  `pickup_point_id` int UNSIGNED NOT NULL,
  `address_text` varchar(255) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `pickup_points`
--

INSERT INTO `pickup_points` (`pickup_point_id`, `address_text`) VALUES
(2, '125061, г. Лесной, ул. Подгорная, 8'),
(29, '125703, г. Лесной, ул. Партизанская, 49'),
(28, '125837, г. Лесной, ул. Шоссейная, 40'),
(36, '190949, г. Лесной, ул. Мичурина, 26'),
(24, '344288, г. Лесной, ул. Чехова, 1'),
(16, '394060, г.Лесной, ул. Фрунзе, 43'),
(26, '394242, г. Лесной, ул. Коммунистическая, 43'),
(21, '394782, г. Лесной, ул. Чехова, 3'),
(4, '400562, г. Лесной, ул. Зеленая, 32'),
(11, '410172, г. Лесной, ул. Северная, 13'),
(6, '410542, г. Лесной, ул. Светлая, 46'),
(17, '410661, г. Лесной, ул. Школьная, 50'),
(1, '420151, г. Лесной, ул. Вишневая, 32'),
(32, '426030, г. Лесной, ул. Маяковского, 44'),
(8, '443890, г. Лесной, ул. Коммунистическая, 1'),
(33, '450375, г. Лесной ул. Клубная, 44'),
(23, '450558, г. Лесной, ул. Набережная, 30'),
(20, '450983, г.Лесной, ул. Комсомольская, 26'),
(13, '454311, г.Лесной, ул. Новая, 19'),
(22, '603002, г. Лесной, ул. Дзержинского, 28'),
(15, '603036, г. Лесной, ул. Садовая, 4'),
(9, '603379, г. Лесной, ул. Спортивная, 46'),
(10, '603721, г. Лесной, ул. Гоголя, 41'),
(25, '614164, г.Лесной,  ул. Степная, 30'),
(5, '614510, г. Лесной, ул. Маяковского, 47'),
(12, '614611, г. Лесной, ул. Молодежная, 50'),
(31, '614753, г. Лесной, ул. Полевая, 35'),
(7, '620839, г. Лесной, ул. Цветочная, 8'),
(30, '625283, г. Лесной, ул. Победы, 46'),
(34, '625560, г. Лесной, ул. Некрасова, 12'),
(18, '625590, г. Лесной, ул. Коммунистическая, 20'),
(19, '625683, г. Лесной, ул. 8 Марта'),
(35, '630201, г. Лесной, ул. Комсомольская, 17'),
(3, '630370, г. Лесной, ул. Шоссейная, 24'),
(14, '660007, г.Лесной, ул. Октябрьская, 19'),
(27, '660540, г. Лесной, ул. Солнечная, 25');

-- --------------------------------------------------------

--
-- Структура таблицы `pickup_points_import_raw`
--

CREATE TABLE `pickup_points_import_raw` (
  `raw_id` int UNSIGNED NOT NULL,
  `address_text` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `pickup_points_import_raw`
--

INSERT INTO `pickup_points_import_raw` (`raw_id`, `address_text`) VALUES
(1, '420151, г. Лесной, ул. Вишневая, 32'),
(2, '125061, г. Лесной, ул. Подгорная, 8'),
(3, '630370, г. Лесной, ул. Шоссейная, 24'),
(4, '400562, г. Лесной, ул. Зеленая, 32'),
(5, '614510, г. Лесной, ул. Маяковского, 47'),
(6, '410542, г. Лесной, ул. Светлая, 46'),
(7, '620839, г. Лесной, ул. Цветочная, 8'),
(8, '443890, г. Лесной, ул. Коммунистическая, 1'),
(9, '603379, г. Лесной, ул. Спортивная, 46'),
(10, '603721, г. Лесной, ул. Гоголя, 41'),
(11, '410172, г. Лесной, ул. Северная, 13'),
(12, '614611, г. Лесной, ул. Молодежная, 50'),
(13, '454311, г.Лесной, ул. Новая, 19'),
(14, '660007, г.Лесной, ул. Октябрьская, 19'),
(15, '603036, г. Лесной, ул. Садовая, 4'),
(16, '394060, г.Лесной, ул. Фрунзе, 43'),
(17, '410661, г. Лесной, ул. Школьная, 50'),
(18, '625590, г. Лесной, ул. Коммунистическая, 20'),
(19, '625683, г. Лесной, ул. 8 Марта'),
(20, '450983, г.Лесной, ул. Комсомольская, 26'),
(21, '394782, г. Лесной, ул. Чехова, 3'),
(22, '603002, г. Лесной, ул. Дзержинского, 28'),
(23, '450558, г. Лесной, ул. Набережная, 30'),
(24, '344288, г. Лесной, ул. Чехова, 1'),
(25, '614164, г.Лесной,  ул. Степная, 30'),
(26, '394242, г. Лесной, ул. Коммунистическая, 43'),
(27, '660540, г. Лесной, ул. Солнечная, 25'),
(28, '125837, г. Лесной, ул. Шоссейная, 40'),
(29, '125703, г. Лесной, ул. Партизанская, 49'),
(30, '625283, г. Лесной, ул. Победы, 46'),
(31, '614753, г. Лесной, ул. Полевая, 35'),
(32, '426030, г. Лесной, ул. Маяковского, 44'),
(33, '450375, г. Лесной ул. Клубная, 44'),
(34, '625560, г. Лесной, ул. Некрасова, 12'),
(35, '630201, г. Лесной, ул. Комсомольская, 17'),
(36, '190949, г. Лесной, ул. Мичурина, 26');

-- --------------------------------------------------------

--
-- Структура таблицы `products`
--

CREATE TABLE `products` (
  `product_id` int UNSIGNED NOT NULL,
  `article` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `unit_name` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `price` decimal(12,2) NOT NULL,
  `supplier_id` int UNSIGNED NOT NULL,
  `manufacturer_id` int UNSIGNED NOT NULL,
  `category_id` int UNSIGNED NOT NULL,
  `discount_percent` decimal(5,2) NOT NULL,
  `stock_quantity` int NOT NULL,
  `description_text` text COLLATE utf8mb4_general_ci,
  `photo_file` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL
) ;

--
-- Дамп данных таблицы `products`
--

INSERT INTO `products` (`product_id`, `article`, `name`, `unit_name`, `price`, `supplier_id`, `manufacturer_id`, `category_id`, `discount_percent`, `stock_quantity`, `description_text`, `photo_file`) VALUES
(1, 'PMEZMH', 'Цемент', 'шт.', '440.00', 1, 1, 1, '8.00', 34, 'Цемент Евроцемент М500 Д0 ЦЕМ I 42,5 50 кг', 'PMEZMH.jpg'),
(2, 'BPV4MM', 'Пленка техническая', 'шт.', '8.00', 2, 2, 1, '8.00', 2, 'Пленка техническая полиэтиленовая Изостронг 60 мк 3 м рукав 1,5 м, пог.м', 'BPV4MM.jpg'),
(3, 'JVL42J', 'Пленка техническая', 'шт.', '13.00', 2, 2, 1, '4.00', 34, 'Пленка техническая полиэтиленовая Изостронг 100 мк 3 м рукав 1,5 м, пог.м', 'JVL42J.jpg'),
(4, 'F895RB', 'Песок строительный', 'шт.', '102.00', 3, 3, 1, '6.00', 7, 'Песок строительный 50 кг', 'F895RB.jpg'),
(5, '3XBOTN', 'Керамзит фракция', 'шт.', '110.00', 4, 4, 1, '5.00', 21, 'Керамзит фракция 10-20 мм 0,05 куб.м', '3XBOTN.jpg'),
(6, '3L7RCZ', 'Газобетон', 'шт.', '7400.00', 5, 5, 2, '2.00', 20, 'Газобетон ЛСР 100х250х625 мм D400', '3L7RCZ.jpg'),
(7, 'S72AM3', 'Пазогребневая плита', 'шт.', '500.00', 6, 6, 2, '5.00', 35, 'Пазогребневая плита ВОЛМА Гидро 667х500х80 мм полнотелая', 'S72AM3.jpg'),
(8, '2G3280', 'Угол наружный', 'шт.', '795.00', 7, 7, 2, '9.00', 20, 'Угол наружный Vinylon 3050 мм серо-голубой', '2G3280.jpg'),
(9, 'MIO8YV', 'Кирпич', 'шт.', '30.00', 6, 6, 2, '9.00', 31, 'Кирпич рядовой Боровичи полнотелый М150 250х120х65 мм 1NF', 'MIO8YV.jpg'),
(10, 'UER2QD', 'Скоба для пазогребневой плиты', 'шт.', '25.00', 3, 3, 2, '8.00', 27, 'Скоба для пазогребневой плиты Knauf С1 120х100 мм', 'UER2QD.jpg'),
(11, 'ZR70B4', 'Кирпич', 'шт.', '16.00', 8, 8, 2, '3.00', 0, 'Кирпич рядовой силикатный Павловский завод полнотелый М200 250х120х65 мм 1NF', NULL),
(12, 'LPDDM4', 'Штукатурка гипсовая', 'шт.', '500.00', 3, 3, 3, '6.00', 38, 'Штукатурка гипсовая Knauf Ротбанд 30 кг', NULL),
(13, 'LQ48MW', 'Штукатурка гипсовая', 'шт.', '462.00', 9, 9, 3, '6.00', 33, 'Штукатурка гипсовая Knauf МП-75 машинная 30 кг', NULL),
(14, 'O43COU', 'Шпаклевка', 'шт.', '750.00', 6, 6, 3, '1.00', 16, 'Шпаклевка полимерная Weber.vetonit LR + для сухих помещений белая 20 кг', NULL),
(15, 'M26EXW', 'Клей для плитки, керамогранита и камня', 'шт.', '340.00', 3, 3, 3, '8.00', 0, 'Клей для плитки, керамогранита и камня Крепс Усиленный серый (класс С1) 25 кг', NULL),
(16, 'K0YACK', 'Смесь цементно-песчаная', 'шт.', '160.00', 4, 4, 3, '8.00', 19, 'Смесь цементно-песчаная (ЦПС) 300 по ТУ MixMaster Универсал 25 кг', NULL),
(17, 'ASPXSG', 'Ровнитель', 'шт.', '711.00', 9, 9, 3, '10.00', 20, 'Ровнитель (наливной пол) финишный Weber.vetonit 4100 самовыравнивающийся высокопрочный 20 кг', NULL),
(18, 'ZKQ5FF', 'Лезвие для ножа', 'шт.', '65.00', 10, 10, 4, '6.00', 6, 'Лезвие для ножа Hesler 18 мм прямое (10 шт.)', NULL),
(19, '4WZEOT', 'Лезвие для ножа', 'шт.', '210.00', 11, 11, 4, '10.00', 17, 'Лезвие для ножа Armero 18 мм прямое (10 шт.)', ''),
(20, '4JR1HN', 'Шпатель', 'шт.', '26.00', 10, 10, 4, '6.00', 7, 'Шпатель малярный 100 мм с пластиковой ручкой', NULL),
(21, 'Z3XFSP', 'Нож строительный', 'шт.', '63.00', 10, 10, 4, '8.00', 5, 'Нож строительный Hesler 18 мм с ломающимся лезвием пластиковый корпус', NULL),
(22, 'I6MH89', 'Валик', 'шт.', '326.00', 12, 12, 4, '12.00', 3, 'Валик Wenzo Roma полиакрил 250 мм ворс 18 мм для красок грунтов и антисептиков на водной основе с рукояткой', NULL),
(23, '83M5ME', 'Кисть', 'шт.', '122.00', 11, 11, 4, '9.00', 26, 'Кисть плоская смешанная щетина 100х12 мм для красок и антисептиков на водной основе', NULL),
(24, '61PGH3', 'Очки защитные', 'шт.', '184.00', 13, 13, 5, '6.00', 25, 'Очки защитные Delta Plus KILIMANDJARO (KILIMGRIN) открытые с прозрачными линзами', NULL),
(25, 'GN6ICZ', 'Каска защитная', 'шт.', '154.00', 14, 14, 5, '15.00', 8, 'Каска защитная Исток (КАС001О) оранжевая', ''),
(26, 'Z3LO0U', 'Очки защитные', 'шт.', '228.00', 15, 15, 5, '9.00', 11, 'Очки защитные Delta Plus RUIZ (RUIZ1VI) закрытые с прозрачными линзами', NULL),
(27, 'QHNOKR', 'Маска защитная', 'шт.', '251.00', 14, 14, 5, '2.00', 22, 'Маска защитная Исток (ЩИТ001) ударопрочная и термостойкая', NULL),
(28, 'EQ6RKO', 'Подшлемник', 'шт.', '36.00', 16, 16, 5, '17.00', 22, 'Подшлемник для каски одноразовый', NULL),
(29, '81F1WG', 'Каска защитная', 'шт.', '1500.00', 17, 17, 5, '2.00', 13, 'Каска защитная Delta Plus BASEBALL DIAMOND V UP (DIAM5UPBCFLBS) белая', NULL),
(30, '0YGHZ7', 'Очки защитные', 'шт.', '700.00', 16, 16, 5, '9.00', 36, 'Очки защитные Husqvarna Clear (5449638-01) открытые с прозрачными линзами', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `products_import_raw`
--

CREATE TABLE `products_import_raw` (
  `article_text` varchar(60) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `name_text` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `unit_text` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `price_text` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `supplier_text` varchar(120) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `manufacturer_text` varchar(120) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `category_text` varchar(120) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `discount_text` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `stock_text` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description_text` text COLLATE utf8mb4_general_ci,
  `photo_text` varchar(120) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `products_import_raw`
--

INSERT INTO `products_import_raw` (`article_text`, `name_text`, `unit_text`, `price_text`, `supplier_text`, `manufacturer_text`, `category_text`, `discount_text`, `stock_text`, `description_text`, `photo_text`) VALUES
('PMEZMH', 'Цемент', 'шт.', '440', 'М500', 'М500', 'Общестроительные материалы', '8', '34', 'Цемент Евроцемент М500 Д0 ЦЕМ I 42,5 50 кг', 'PMEZMH.jpg'),
('BPV4MM', 'Пленка техническая', 'шт.', '8', 'Изостронг', 'Изостронг', 'Общестроительные материалы', '8', '2', 'Пленка техническая полиэтиленовая Изостронг 60 мк 3 м рукав 1,5 м, пог.м', 'BPV4MM.jpg'),
('JVL42J', 'Пленка техническая', 'шт.', '13', 'Изостронг', 'Изостронг', 'Общестроительные материалы', '4', '34', 'Пленка техническая полиэтиленовая Изостронг 100 мк 3 м рукав 1,5 м, пог.м', 'JVL42J.jpg'),
('F895RB', 'Песок строительный', 'шт.', '102', 'Knauf', 'Knauf', 'Общестроительные материалы', '6', '7', 'Песок строительный 50 кг', 'F895RB.jpg'),
('3XBOTN', 'Керамзит фракция', 'шт.', '110', 'MixMaster', 'MixMaster', 'Общестроительные материалы', '5', '21', 'Керамзит фракция 10-20 мм 0,05 куб.м', '3XBOTN.jpg'),
('3L7RCZ', 'Газобетон', 'шт.', '7400', 'ЛСР', 'ЛСР', 'Стеновые и фасадные материалы', '2', '20', 'Газобетон ЛСР 100х250х625 мм D400', '3L7RCZ.jpg'),
('S72AM3', 'Пазогребневая плита ', 'шт.', '500', 'ВОЛМА', 'ВОЛМА', 'Стеновые и фасадные материалы', '5', '35', 'Пазогребневая плита ВОЛМА Гидро 667х500х80 мм полнотелая', 'S72AM3.jpg'),
('2G3280', 'Угол наружный', 'шт.', '795', 'Vinylon', 'Vinylon', 'Стеновые и фасадные материалы', '9', '20', 'Угол наружный Vinylon 3050 мм серо-голубой', '2G3280.jpg'),
('MIO8YV', 'Кирпич', 'шт.', '30', 'ВОЛМА', 'ВОЛМА', 'Стеновые и фасадные материалы', '9', '31', 'Кирпич рядовой Боровичи полнотелый М150 250х120х65 мм 1NF', 'MIO8YV.jpg'),
('UER2QD', 'Скоба для пазогребневой плиты', 'шт.', '25', 'Knauf', 'Knauf', 'Стеновые и фасадные материалы', '8', '27', 'Скоба для пазогребневой плиты Knauf С1 120х100 мм', 'UER2QD.jpg'),
('ZR70B4', 'Кирпич', 'шт.', '16', 'Павловский завод ', 'Павловский завод ', 'Стеновые и фасадные материалы', '3', '0', 'Кирпич рядовой силикатный Павловский завод полнотелый М200 250х120х65 мм 1NF', ''),
('LPDDM4', 'Штукатурка гипсовая', 'шт.', '500', 'Knauf', 'Knauf', 'Сухие строительные смеси и гидроизоляция', '6', '38', 'Штукатурка гипсовая Knauf Ротбанд 30 кг', ''),
('LQ48MW', 'Штукатурка гипсовая', 'шт.', '462', 'Weber', 'Weber', 'Сухие строительные смеси и гидроизоляция', '6', '33', 'Штукатурка гипсовая Knauf МП-75 машинная 30 кг', ''),
('O43COU', 'Шпаклевка', 'шт.', '750', 'ВОЛМА', 'ВОЛМА', 'Сухие строительные смеси и гидроизоляция', '1', '16', 'Шпаклевка полимерная Weber.vetonit LR + для сухих помещений белая 20 кг', ''),
('M26EXW', 'Клей для плитки, керамогранита и камня', 'шт.', '340', 'Knauf', 'Knauf', 'Сухие строительные смеси и гидроизоляция', '8', '0', 'Клей для плитки, керамогранита и камня Крепс Усиленный серый (класс С1) 25 кг', ''),
('K0YACK', 'Смесь цементно-песчаная', 'шт.', '160', 'MixMaster', 'MixMaster', 'Сухие строительные смеси и гидроизоляция', '8', '19', 'Смесь цементно-песчаная (ЦПС) 300 по ТУ MixMaster Универсал 25 кг', ''),
('ASPXSG', 'Ровнитель', 'шт.', '711', 'Weber', 'Weber', 'Сухие строительные смеси и гидроизоляция', '10', '20', 'Ровнитель (наливной пол) финишный Weber.vetonit 4100 самовыравнивающийся высокопрочный 20 кг', ''),
('ZKQ5FF', 'Лезвие для ножа ', 'шт.', '65', 'Hesler', 'Hesler', 'Ручной инструмент', '6', '6', 'Лезвие для ножа Hesler 18 мм прямое (10 шт.)', ''),
('4WZEOT', 'Лезвие для ножа ', 'шт.', '110', 'Armero', 'Armero', 'Ручной инструмент', '6', '17', 'Лезвие для ножа Armero 18 мм прямое (10 шт.)', ''),
('4JR1HN', 'Шпатель', 'шт.', '26', 'Hesler', 'Hesler', 'Ручной инструмент', '6', '7', 'Шпатель малярный 100 мм с пластиковой ручкой', ''),
('Z3XFSP', 'Нож строительный ', 'шт.', '63', 'Hesler', 'Hesler', 'Ручной инструмент', '8', '5', 'Нож строительный Hesler 18 мм с ломающимся лезвием пластиковый корпус', ''),
('I6MH89', 'Валик', 'шт.', '326', 'Wenzo Roma', 'Wenzo Roma', 'Ручной инструмент', '12', '3', 'Валик Wenzo Roma полиакрил 250 мм ворс 18 мм для красок грунтов и антисептиков на водной основе с рукояткой', ''),
('83M5ME', 'Кисть', 'шт.', '122', 'Armero', 'Armero', 'Ручной инструмент', '9', '26', 'Кисть плоская смешанная щетина 100х12 мм для красок и антисептиков на водной основе', ''),
('61PGH3', 'Очки защитные', 'шт.', '184', 'KILIMGRIN', 'KILIMGRIN', 'Защита лица, глаз, головы', '6', '25', 'Очки защитные Delta Plus KILIMANDJARO (KILIMGRIN) открытые с прозрачными линзами', ''),
('GN6ICZ', 'Каска защитная ', 'шт.', '154', 'Исток', 'Исток', 'Защита лица, глаз, головы', '15', '8', 'Каска защитная Исток (КАС001О) оранжевая', ''),
('Z3LO0U', 'Очки защитные ', 'шт.', '228', 'RUIZ', 'RUIZ', 'Защита лица, глаз, головы', '9', '11', 'Очки защитные Delta Plus RUIZ (RUIZ1VI) закрытые с прозрачными линзами', ''),
('QHNOKR', 'Маска защитная', 'шт.', '251', 'Исток', 'Исток', 'Защита лица, глаз, головы', '2', '22', 'Маска защитная Исток (ЩИТ001) ударопрочная и термостойкая', ''),
('EQ6RKO', 'Подшлемник', 'шт.', '36', 'Husqvarna', 'Husqvarna', 'Защита лица, глаз, головы', '17', '22', 'Подшлемник для каски одноразовый', ''),
('81F1WG', 'Каска защитная', 'шт.', '1500', 'Delta', 'Delta', 'Защита лица, глаз, головы', '2', '13', 'Каска защитная Delta Plus BASEBALL DIAMOND V UP (DIAM5UPBCFLBS) белая', ''),
('0YGHZ7', 'Очки защитные ', 'шт.', '700', 'Husqvarna', 'Husqvarna', 'Защита лица, глаз, головы', '9', '36', 'Очки защитные Husqvarna Clear (5449638-01) открытые с прозрачными линзами', '');

-- --------------------------------------------------------

--
-- Структура таблицы `roles`
--

CREATE TABLE `roles` (
  `role_id` tinyint UNSIGNED NOT NULL,
  `role_name` varchar(60) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`) VALUES
(2, 'Авторизированный клиент'),
(4, 'Администратор'),
(1, 'Гость'),
(3, 'Менеджер');

-- --------------------------------------------------------

--
-- Структура таблицы `suppliers`
--

CREATE TABLE `suppliers` (
  `supplier_id` int UNSIGNED NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `suppliers`
--

INSERT INTO `suppliers` (`supplier_id`, `name`) VALUES
(1, 'М500'),
(2, 'Изостронг'),
(3, 'Knauf'),
(4, 'MixMaster'),
(5, 'ЛСР'),
(6, 'ВОЛМА'),
(7, 'Vinylon'),
(8, 'Павловский завод'),
(9, 'Weber'),
(10, 'Hesler'),
(11, 'Armero'),
(12, 'Wenzo Roma'),
(13, 'KILIMGRIN'),
(14, 'Исток'),
(15, 'RUIZ'),
(16, 'Husqvarna'),
(17, 'Delta');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `user_id` int UNSIGNED NOT NULL,
  `role_id` tinyint UNSIGNED NOT NULL,
  `full_name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `login` varchar(120) COLLATE utf8mb4_general_ci NOT NULL,
  `password_plain` varchar(120) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`user_id`, `role_id`, `full_name`, `login`, `password_plain`) VALUES
(1, 4, 'Ворсин Петр Евгеньевич', '94d5ous@gmail.com', 'uzWC67'),
(2, 4, 'Старикова Елена Павловна', 'uth4iz@mail.com', '2L6KZG'),
(3, 4, 'Одинцов Серафим Артёмович', 'yzls62@outlook.com', 'JlFRCZ'),
(4, 3, 'Степанов Михаил Артёмович', '1diph5e@tutanota.com', '8ntwUp'),
(5, 3, 'Ворсин Петр Евгеньевич', 'tjde7c@yahoo.com', 'YOyhfR'),
(6, 3, 'Старикова Елена Павловна', 'wpmrc3do@tutanota.com', 'RSbvHv'),
(7, 2, 'Михайлюк Анна Вячеславовна', '5d4zbu@tutanota.com', 'rwVDh9'),
(8, 2, 'Ситдикова Елена Анатольевна', 'ptec8ym@yahoo.com', 'LdNyos'),
(9, 2, 'Никифорова Весения Николаевна', '1qz4kw@mail.com', 'gynQMT'),
(10, 2, 'Сазонов Руслан Германович', '4np6se@mail.com', 'AtnDjr'),
(11, 4, 'Администратор', 'admin@gmail.com', 'admin');

-- --------------------------------------------------------

--
-- Структура таблицы `users_import_raw`
--

CREATE TABLE `users_import_raw` (
  `role_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `full_name` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `login_text` varchar(120) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password_text` varchar(120) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `users_import_raw`
--

INSERT INTO `users_import_raw` (`role_name`, `full_name`, `login_text`, `password_text`) VALUES
('Администратор', 'Ворсин Петр Евгеньевич', '94d5ous@gmail.com', 'uzWC67'),
('Администратор', 'Старикова Елена Павловна', 'uth4iz@mail.com', '2L6KZG'),
('Администратор', 'Одинцов Серафим Артёмович', 'yzls62@outlook.com', 'JlFRCZ'),
('Менеджер', 'Степанов Михаил Артёмович', '1diph5e@tutanota.com', '8ntwUp'),
('Менеджер', 'Ворсин Петр Евгеньевич', 'tjde7c@yahoo.com', 'YOyhfR'),
('Менеджер', 'Старикова Елена Павловна', 'wpmrc3do@tutanota.com', 'RSbvHv'),
('Авторизированный клиент', 'Михайлюк Анна Вячеславовна', '5d4zbu@tutanota.com', 'rwVDh9'),
('Авторизированный клиент', 'Ситдикова Елена Анатольевна', 'ptec8ym@yahoo.com', 'LdNyos'),
('Авторизированный клиент', 'Никифорова Весения Николаевна', '1qz4kw@mail.com', 'gynQMT'),
('Авторизированный клиент', 'Сазонов Руслан Германович', '4np6se@mail.com', 'AtnDjr');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `manufacturers`
--
ALTER TABLE `manufacturers`
  ADD PRIMARY KEY (`manufacturer_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD UNIQUE KEY `order_number` (`order_number`),
  ADD KEY `fk_orders_pickup_points` (`pickup_point_id`),
  ADD KEY `fk_orders_statuses` (`status_id`);

--
-- Индексы таблицы `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Индексы таблицы `order_statuses`
--
ALTER TABLE `order_statuses`
  ADD PRIMARY KEY (`status_id`),
  ADD UNIQUE KEY `status_name` (`status_name`);

--
-- Индексы таблицы `pickup_points`
--
ALTER TABLE `pickup_points`
  ADD PRIMARY KEY (`pickup_point_id`),
  ADD UNIQUE KEY `address_text` (`address_text`);

--
-- Индексы таблицы `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `manufacturer_id` (`manufacturer_id`),
  ADD KEY `category_id_2` (`category_id`),
  ADD KEY `manufacturer_id_2` (`manufacturer_id`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `supplier_id_2` (`supplier_id`);

--
-- Индексы таблицы `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `role_name` (`role_name`);

--
-- Индексы таблицы `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `role_id` (`role_id`),
  ADD KEY `role_id_2` (`role_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `manufacturers`
--
ALTER TABLE `manufacturers`
  MODIFY `manufacturer_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT для таблицы `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `order_statuses`
--
ALTER TABLE `order_statuses`
  MODIFY `status_id` tinyint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplier_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_pickup_points` FOREIGN KEY (`pickup_point_id`) REFERENCES `pickup_points` (`pickup_point_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_orders_statuses` FOREIGN KEY (`status_id`) REFERENCES `order_statuses` (`status_id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_orderitems_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_orderitems_products` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_product_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_product_manufacturer` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturers` (`manufacturer_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_product_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE RESTRICT ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
