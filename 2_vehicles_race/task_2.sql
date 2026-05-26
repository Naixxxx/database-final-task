-- Решение второй задачи

SELECT
    c.name AS car_name,
    c.class AS car_class,
    AVG(r.position)::NUMERIC(10, 4) AS average_position,
    COUNT(r.race) AS race_count,
    cl.country AS car_country
FROM Cars c
JOIN Results r ON c.name = r.car
JOIN Classes cl ON c.class = cl.class
GROUP BY c.name, c.class, cl.country
ORDER BY average_position ASC, c.name ASC
LIMIT 1;
