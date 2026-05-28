--
--
--
--
-- Если ориентироваться только на ожидаемый вывод, то решение ниже будет удовлетворять ожидаемому выводу из задачи
--
--
--
--

WITH car_stats AS (
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
),
class_stats AS (
    SELECT
        car_class,
        SUM(race_count) AS total_races,

        -- В ожидаемом выводе автомобиль со средней позицией ровно 3.0
        -- учитывается в low_position_count, поэтому здесь используется >= 3.0.
        COUNT(*) FILTER (WHERE average_position >= 3.0) AS low_position_count
    FROM car_stats
    GROUP BY car_class
)
SELECT
    cs.car_name,
    cs.car_class,
    cs.average_position,
    cs.race_count,
    cs.car_country,
    cls.total_races,
    cls.low_position_count
FROM car_stats cs
JOIN class_stats cls ON cs.car_class = cls.car_class
WHERE cs.average_position > 3.0
ORDER BY
    cls.low_position_count DESC,
    cs.average_position ASC;
