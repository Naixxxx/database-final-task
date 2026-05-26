-- Решение третьей задачи

WITH hotel_categories AS (
    -- Определяем категорию каждого отеля по средней цене его номеров
    -- Сначала считаем AVG(r.price) по всем комнатам отеля
    -- затем через CASE присваиваем категорию:
    -- меньше 175  -> Дешевый
    -- 175-300     -> Средний
    -- больше 300  -> Дорогой
    SELECT
        h.ID_hotel,
        h.name AS hotel_name,
        AVG(r.price) AS average_room_price,
        CASE
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_category
    FROM Hotel h
    JOIN Room r ON h.ID_hotel = r.ID_hotel
    GROUP BY
        h.ID_hotel,
        h.name
),

customer_hotels AS (
    -- Получаем уникальные пары клиент -> посещенный отель
    -- DISTINCT нужен, чтобы один и тот же отель не повторялся у клиента
    -- если клиент бронировал в этом отеле несколько раз.
    SELECT DISTINCT c.ID_customer, c.name, hc.ID_hotel, hc.hotel_name, hc.hotel_category
    FROM Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN hotel_categories hc ON r.ID_hotel = hc.ID_hotel
),

customer_preferences AS (
    -- Определяем предпочитаемый тип отеля для каждого клиента
    -- Приоритет такой
    -- если есть хотя бы один дорогой отель -> Дорогой
    -- иначе если есть хотя бы один средний -> Средний
    -- иначе -> Дешевый.
    -- Также собираем список уникальных посещенных отелей в одну строку
    SELECT
        ID_customer,
        name,
        CASE
            WHEN COUNT(*) FILTER (WHERE hotel_category = 'Дорогой') > 0 THEN 'Дорогой'
            WHEN COUNT(*) FILTER (WHERE hotel_category = 'Средний') > 0 THEN 'Средний'
            ELSE 'Дешевый'
        END AS preferred_hotel_type,
        STRING_AGG(hotel_name, ',' ORDER BY hotel_name) AS visited_hotels
    FROM customer_hotels
    GROUP BY
        ID_customer,
        name
)

SELECT
    ID_customer,
    name,
    preferred_hotel_type,
    visited_hotels
FROM customer_preferences

ORDER BY
    CASE preferred_hotel_type
        WHEN 'Дешевый' THEN 1
        WHEN 'Средний' THEN 2
        WHEN 'Дорогой' THEN 3
    END,
    ID_customer;
