-- Решение второй задачи
-- В ожидаемом выводе total_spent считается как сумма цен забронированных номеров, без умножения на количество ночей. Поэтому используется SUM(r.price)

WITH booking_stats AS (
    SELECT
        c.ID_customer,
        c.name,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS unique_hotels,
        SUM(r.price)::NUMERIC(10, 2) AS total_spent
    FROM Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY
        c.ID_customer,
        c.name
),
multi_hotel_customers AS (
    SELECT ID_customer, name, total_bookings, unique_hotels, total_spent
    FROM booking_stats
    WHERE total_bookings > 2
      AND unique_hotels > 1
),
high_spending_customers AS (
    SELECT ID_customer, name, total_spent, total_bookings
    FROM booking_stats
    WHERE total_spent > 500
)
SELECT mh.ID_customer, mh.name, mh.total_bookings, mh.total_spent, mh.unique_hotels
FROM multi_hotel_customers mh
JOIN high_spending_customers hs
    ON mh.ID_customer = hs.ID_customer
ORDER BY mh.total_spent ASC;
