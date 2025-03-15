-- Таблица ресторан
CREATE TABLE restaurant (
    id SERIAL PRIMARY KEY,  
    phone_number CHAR(12) UNIQUE NOT NULL CHECK (phone_number ~ '^\+7[0-9]{10}$'), 
    settlement VARCHAR(50) NOT NULL,
    street VARCHAR(50) NOT NULL,
    building VARCHAR(10) NOT NULL,
    open_time TIME NOT NULL,
    close_time TIME NOT NULL,
    UNIQUE (settlement, street, building)
);


-- Таблица клиент
CREATE TABLE client (
    id SERIAL PRIMARY KEY,  
    phone_number CHAR(12) UNIQUE NOT NULL CHECK (phone_number ~ '^\+7[0-9]{10}$'), 
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    bonuses INT NOT NULL CHECK (bonuses >= 0) DEFAULT 100
);

-- Таблица бронирование столов
CREATE TABLE table_reservation (
    id SERIAL PRIMARY KEY,
    table_number INT NOT NULL,
    people_count INT NOT NULL CHECK (people_count > 0),
    reservation_date_time TIMESTAMP NOT NULL,
    client_id INT NOT NULL,  
    restaurant_id INT NOT NULL,  
    UNIQUE (reservation_date_time, client_id),
    UNIQUE (table_number, restaurant_id, reservation_date_time),
    FOREIGN KEY (client_id) REFERENCES client(id) 
        ON DELETE CASCADE
		ON UPDATE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurant(id) 
        ON DELETE CASCADE
	ON UPDATE CASCADE
);

-- Таблица сотрудник
CREATE TABLE employee (
    id SERIAL PRIMARY KEY,
    passport_number VARCHAR(15) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    phone_number CHAR(12) UNIQUE NOT NULL CHECK (phone_number ~ '^\+7[0-9]{10}$'),
    hire_date DATE NOT NULL,
    salary NUMERIC(10, 2) NOT NULL CHECK (salary >= 0),
    restaurant_id INT,
    FOREIGN KEY (restaurant_id) REFERENCES restaurant(id) 
        ON DELETE SET NULL 
		ON UPDATE CASCADE
);

-- Таблица заказ
CREATE TABLE "order" (
    id SERIAL PRIMARY KEY,
    order_date_time TIMESTAMP NOT NULL,
    total_amount NUMERIC(10, 2) NOT NULL CHECK (total_amount >= 0),
    employee_id INT,
    client_id INT,
    UNIQUE (order_date_time, employee_id),
    UNIQUE (order_date_time, client_id),
    FOREIGN KEY (employee_id) REFERENCES employee(id) 
        ON DELETE SET NULL
		ON UPDATE CASCADE,
    FOREIGN KEY (client_id) REFERENCES client(id) 
        ON DELETE SET NULL
		ON UPDATE CASCADE
);

-- Таблица блюдо
CREATE TABLE dish (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0)
);

-- Таблица детали заказа
CREATE TABLE order_details (
    quantity INT NOT NULL CHECK (quantity > 0),
    order_id INT NOT NULL,
    dish_id INT,
    PRIMARY KEY (order_id, dish_id),
    FOREIGN KEY (order_id) REFERENCES "order"(id) 
        ON DELETE CASCADE
		ON UPDATE CASCADE,
    FOREIGN KEY (dish_id) REFERENCES dish(id) 
        ON DELETE SET NULL
		ON UPDATE CASCADE
);

-- Таблица продукт
CREATE TABLE product (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    expiration_days INT NOT NULL CHECK (expiration_days >= 0)
);

-- Таблица поставщик
CREATE TABLE supplier (
    id SERIAL PRIMARY KEY, 
    inn VARCHAR(12) UNIQUE NOT NULL CHECK (inn ~ '^[0-9]{10}$' OR inn ~ '^[0-9]{12}$'),  
    name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100) NOT NULL,
    contact_phone CHAR(12) UNIQUE NOT NULL CHECK (contact_phone ~ '^\+7[0-9]{10}$'),
    contact_email VARCHAR(100) UNIQUE NOT NULL,
    physical_address VARCHAR(200) UNIQUE NOT NULL
);

-- Таблица поставка
CREATE TABLE delivery (
    id SERIAL PRIMARY KEY,
    delivery_date_time TIMESTAMP NOT NULL,
    production_date DATE NOT NULL,
    weight NUMERIC(10, 2) NOT NULL CHECK (weight > 0),
    product_id INT,
    restaurant_id INT NOT NULL,
    supplier_id INT,
    UNIQUE (delivery_date_time, restaurant_id),
    FOREIGN KEY (product_id) REFERENCES product(id) 
        ON DELETE SET NULL
		ON UPDATE CASCADE,
    FOREIGN KEY (supplier_id) REFERENCES supplier(id) 
        ON DELETE SET NULL
		ON UPDATE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurant(id) 
        ON DELETE CASCADE
		ON UPDATE CASCADE,
    CHECK (delivery_date_time > production_date)
);


-- Заполнение таблицы блюдо
INSERT INTO dish (name, description, price) VALUES
('Пицца Маргарита', 'Классическая пицца с моцареллой, помидорами и базиликом', 500.00),
('Суши набор', 'Набор роллов с лососем, тунцом и авокадо', 800.00),
('Борщ', 'Традиционный украинский борщ с мясом и сметаной', 250.00),
('Цезарь', 'Салат Цезарь с курицей, соусом и пармезаном', 350.00),
('Шашлык из баранины', 'Шашлык из свежей баранины с овощами', 700.00);


-- Заполнение таблицы ресторан
-- Заполнение таблицы ресторан
INSERT INTO restaurant (phone_number, settlement, street, building, open_time, close_time) VALUES
('+79991234567', 'Москва', 'Ленина', '10', '09:00:00', '22:00:00'),
('+79992345678', 'Санкт-Петербург', 'Невский', '5', '08:00:00', '21:00:00'),
('+79994567890', 'Казань', 'Пушкина', '25', '10:00:00', '23:00:00'),
('+79995678901', 'Екатеринбург', 'Карла Маркса', '18', '09:30:00', '22:30:00'),
('+79996789012', 'Новосибирск', 'Советская', '12', '07:00:00', '20:00:00');


-- Заполнение таблицы клиент
INSERT INTO client (phone_number, last_name, first_name, middle_name) VALUES
('+79991112233', 'Иванов', 'Иван', 'Иванович'),
('+79992223344', 'Петров', 'Петр', 'Петрович'),
('+79993334455', 'Сидоров', 'Сидор', 'Сидорович'),
('+79994445566', 'Кузнецов', 'Андрей', 'Андреевич'),
('+79995556677', 'Михайлов', 'Алексей', 'Иванович');


-- Заполнение таблицы сотрудник
INSERT INTO employee (passport_number, last_name, first_name, middle_name, phone_number, hire_date, salary, restaurant_id) VALUES
('1234567890', 'Смирнов', 'Алексей', 'Николаевич', '+79995556677', '2023-01-15', 50000, 1),
('2345678901', 'Соколов', 'Дмитрий', 'Вячеславович', '+79993334456', '2022-03-10', 45000, 2),
('3456789012', 'Андреев', 'Никита', 'Валерьевич', '+79992223345', '2021-05-20', 60000, 3),
('4567890123', 'Тимофеев', 'Станислав', 'Романович', '+79991112234', '2022-07-25', 55000, 4),
('5678901234', 'Федоров', 'Владимир', 'Петрович', '+79997778899', '2023-11-01', 52000, 5);


-- Заполнение таблицы продукт
INSERT INTO product (name, expiration_days) VALUES
('Мука', 180),
('Сахар', 3650),
('Соль', 3650),
('Молоко', 7),
('Яйца', 21);


-- Заполнение таблицы поставщик
INSERT INTO supplier (inn, name, contact_name, contact_phone, contact_email, physical_address) VALUES
('123456789012', 'ИП Иванов Иван Иванович', 'Иван', '+79990000001', 'ivanov@mail.ru', 'Москва, ул. Ленина, д. 1'),
('1234567890', 'ООО Ромашка', 'Петр', '+79990000002', 'petrov@mail.ru', 'Санкт-Петербург, ул. Невский, д. 5'),
('987654321012', 'ИП Сидоров Сидор Сидорович', 'Сидор', '+79990000003', 'sidorov@mail.ru', 'Казань, ул. Пушкина, д. 25'),
('111111111111', 'ООО Улыбка', 'Алексей', '+79990000004', 'alekseev@mail.ru', 'Екатеринбург, ул. Карла Маркса, д. 20'),
('222222222222', 'ИП Яковлев Ярослав Яковлевич', 'Ярослав', '+79990000005', 'yakovlev@mail.ru', 'Новосибирск, ул. Советская, д. 10');


-- Заполнение таблицы поставка
INSERT INTO delivery (delivery_date_time, production_date, weight, product_id, restaurant_id, supplier_id) VALUES
('2024-11-01 10:00:00', '2024-10-25', 100.5, 1, 1, 1),
('2024-11-15 14:30:00', '2024-11-10', 50.0, 2, 2, 2),
('2024-11-20 09:00:00', '2024-11-18', 75.3, 3, 3, 3),
('2024-11-25 16:45:00', '2024-11-20', 120.0, 4, 4, 4),
('2024-11-30 08:30:00', '2024-11-25', 80.5, 5, 5, 5);


-- Заполнение таблицы бронирования
INSERT INTO table_reservation (table_number, people_count, reservation_date_time, client_id, restaurant_id) 
VALUES
(1, 4, '2024-11-26 18:00:00', 1, 1),
(2, 2, '2024-11-26 19:30:00', 2, 1),
(3, 3, '2024-11-26 20:00:00', 3, 2),
(4, 5, '2024-11-26 21:00:00', 4, 2),
(5, 6, '2024-11-26 22:00:00', 5, 3);


-- Функция для добавления бонусов при заказе
CREATE OR REPLACE FUNCTION add_bonuses_to_client() 
RETURNS TRIGGER 
LANGUAGE 'plpgsql' AS 
$$
BEGIN
    UPDATE client
    SET bonuses = bonuses + ROUND(NEW.total_amount * 0.05)
    WHERE id = NEW.client_id;
    RETURN NEW;
END;
$$;


CREATE OR REPLACE TRIGGER trigger_add_bonuses
AFTER INSERT ON "order"
FOR EACH ROW
EXECUTE FUNCTION add_bonuses_to_client();


-- Заполнение таблицы заказ
INSERT INTO "order" (order_date_time, total_amount, employee_id, client_id) VALUES
('2024-11-26 12:00:00', 2050.00, 1, 1),
('2024-11-26 13:30:00', 1750.00, 2, 2),
('2024-11-26 15:00:00', 2200.00, 3, 3);


-- Детали для первого заказа
INSERT INTO order_details (order_id, dish_id, quantity) VALUES
(1, 1, 2), -- 2 пиццы Маргарита
(1, 2, 1), -- 1 суши набор
(1, 3, 1); -- 1 борщ


-- Детали для второго заказа
INSERT INTO order_details (order_id, dish_id, quantity) VALUES
(2, 4, 1), -- 1 Цезарь
(2, 5, 2); -- 2 шашлыка из баранины


-- Детали для третьего заказа
INSERT INTO order_details (order_id, dish_id, quantity) VALUES
(3, 1, 3), -- 3 пиццы Маргарита
(3, 4, 2); -- 2 Цезаря


-- Представление для продуктов с истекшим сроком годности
CREATE OR REPLACE VIEW ExpiredProducts AS
SELECT 
    product.name AS product_name, 
    delivery.id AS delivery_id,
    restaurant_id
FROM product 
JOIN delivery ON product.id = delivery.product_id
WHERE CURRENT_DATE >= production_date + (expiration_days || ' days')::interval;


-- Ранжирование работников по выручке за период
CREATE OR REPLACE FUNCTION get_employee_revenue_ranking(
    start_date DATE,
    end_date DATE
)
RETURNS TABLE (
    id INT,
    last_name VARCHAR(50),
    first_name VARCHAR(50),
	restaurant_id INT,
    revenue NUMERIC(10, 2),
    rank_employee INT
)
LANGUAGE 'sql' AS
$$
SELECT 
    e.id, 
    e.last_name, 
    e.first_name, 
	restaurant_id,
    SUM(o.total_amount) AS revenue,
    DENSE_RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS rank_employee
FROM employee e 
JOIN "order" o ON e.id = o.employee_id
WHERE o.order_date_time BETWEEN start_date AND end_date
GROUP BY e.id, e.last_name, e.first_name
ORDER BY revenue DESC;
$$;


-- Бронирование столов, которое будет сегодня в определённом  ресторане
CREATE OR REPLACE FUNCTION get_todays_reservations(
    rest_id INT
)
RETURNS TABLE (
    table_number INT,
    people_count INT,
    reservation_date_time TIMESTAMP
)
LANGUAGE 'sql' AS
$$
SELECT tr.table_number, tr.people_count, tr.reservation_date_time
FROM table_reservation tr
WHERE 
    tr.restaurant_id = rest_id AND 
    tr.reservation_date_time BETWEEN NOW() AND CURRENT_DATE + INTERVAL '1 day';
$$;


-- Ранжирование блюд по продаваемости
CREATE OR REPLACE FUNCTION get_dish_ranking(start_date DATE, end_date DATE)
RETURNS TABLE (
    name TEXT,
    total_count INT,
    rank_dish INT
) LANGUAGE 'sql' AS 
$$
SELECT 
    dish.name, 
    SUM(order_details.quantity) AS total_count,
    DENSE_RANK() OVER (ORDER BY SUM(order_details.quantity) DESC) AS rank_dish
FROM order_details 
JOIN dish ON order_details.dish_id = dish.id
JOIN "order" ON order_details.order_id = "order".id
WHERE "order".order_date_time BETWEEN start_date AND end_date
GROUP BY dish.name
ORDER BY total_count DESC;
$$;


-- Ранжирование ресторанов по выручке
CREATE OR REPLACE FUNCTION get_restaurant_ranking(start_date DATE, end_date DATE)
RETURNS TABLE (
    restaurant_id INT,
    settlement TEXT,
    street TEXT,
    building TEXT,
    revenue NUMERIC,
    restaurant_rank INTEGER
)
LANGUAGE 'sql' AS
$$
SELECT 
    r.id AS restaurant_id,
    r.settlement, 
    r.street, 
    r.building, 
    SUM(o.total_amount) AS revenue,
    DENSE_RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS restaurant_rank
FROM restaurant r
JOIN employee e ON r.id = e.restaurant_id
JOIN "order" o ON e.id = o.employee_id
WHERE o.order_date_time BETWEEN start_date AND end_date
GROUP BY r.id, r.settlement, r.street, r.building;
$$;


-- Процедура для списания бонусов клиента
CREATE OR REPLACE PROCEDURE deduct_bonuses(
    IN p_phone_number CHAR(12),
    IN p_bonuses_to_deduct INT
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    -- Проверяем, хватает ли бонусов у пользователя
    IF NOT EXISTS (
        SELECT 1
        FROM client
        WHERE phone_number = p_phone_number AND bonuses >= p_bonuses_to_deduct
    ) THEN
        RAISE EXCEPTION 'Недостаточно бонусов у пользователя с номером телефона %', p_phone_number;
    END IF;
    -- Если хватает, то списываем бонусы
    UPDATE client
    SET bonuses = bonuses - p_bonuses_to_deduct
    WHERE phone_number = p_phone_number;
END;
$$;
