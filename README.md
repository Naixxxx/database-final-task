# Database Final Task — PostgreSQL Practice

Учебный проект по решению SQL-задач на PostgreSQL.

Проект состоит из четырёх блоков:

1. Транспортные средства
2. Автомобильные гонки
3. Бронирование отелей
4. Структура организации

В каждой части есть SQL-скрипт для создания таблиц, скрипт для наполнения тестовыми данными и отдельные файлы с решениями задач.

---

## Структура проекта

```text
database-final-task/
│
├── 1_vehicles/
│   ├── table_schema.sql
│   ├── data_script.sql
│   ├── task_1.sql
│   └── task_2.sql
│
├── 2_vehicles_race/
│   ├── table_schema.sql
│   ├── data_script.sql
│   ├── task_1.sql
│   ├── task_2.sql
│   ├── task_3.sql
│   ├── task_4.sql
│   └── task_5.sql
│
├── 3_hotels_booking/
│   ├── table_schema.sql
│   ├── data_script.sql
│   ├── task_1.sql
│   ├── task_2.sql
│   └── task_3.sql
│
├── 4_organization_structure/
│   ├── table_schema.sql
│   ├── data_script.sql
│   ├── task_1.sql
│   ├── task_2.sql
│   └── task_3.sql
│
└── README.md
```

---

## Используемые технологии

- PostgreSQL 16
- psql (но подойдет и gui клиент будь то pgAdmin или Dbeaver)

---

## Быстрый старт

### 1. Зайти в PostgreSQL и создать базу данных

```bash
# Клонирование проекта
git clone https://github.com/Naixxxx/database-final-task.git
cd database-final-task

# Вход в psql
psql -U postgres

# Запрос на создание базы данных
CREATE DATABASE database_final_task;

# Инициализация подключения к базе данных
\c database_final_task
```

---

## Запуск заданий

Каждый блок можно запускать независимо.

Общий порядок запуска внутри выбранной папки:

```bash
psql -d database_final_task -f table_schema.sql
psql -d database_final_task -f data_script.sql
psql -d database_final_task -f task_1.sql
psql -d database_final_task -f task_2.sql
```

Если вы уже находитесь внутри `psql`, можно запускать файлы так:

```sql
\i 1_vehicles/table_schema.sql
\i 1_vehicles/data_script.sql
\i 1_vehicles/task_1.sql
\i 1_vehicles/task_2.sql
```

---

## 1. Транспортные средства

Папка:

```text
1_vehicles/
```

Таблицы:

- `Vehicle`
- `Car`
- `Motorcycle`
- `Bicycle`

Запуск:

```sql
\i 1_vehicles/table_schema.sql
\i 1_vehicles/data_script.sql
\i 1_vehicles/task_1.sql
\i 1_vehicles/task_2.sql
```

Задачи:

| Файл | Описание |
|---|---|
| `task_1.sql` | Поиск спортивных мотоциклов мощнее 150 л.с. и дешевле 20 000 |
| `task_2.sql` | Объединение автомобилей, мотоциклов и велосипедов по условиям |

---

## 2. Автомобильные гонки

Папка:

```text
2_vehicles_race/
```

Таблицы:

- `Classes`
- `Cars`
- `Races`
- `Results`

Запуск:

```sql
\i 2_vehicles_race/table_schema.sql
\i 2_vehicles_race/data_script.sql
\i 2_vehicles_race/task_1.sql
\i 2_vehicles_race/task_2.sql
\i 2_vehicles_race/task_3.sql
\i 2_vehicles_race/task_4.sql
\i 2_vehicles_race/task_5.sql
```

Задачи:

| Файл | Описание |
|---|---|
| `task_1.sql` | Лучшие автомобили каждого класса по средней позиции |
| `task_2.sql` | Лучший автомобиль среди всех автомобилей |
| `task_3.sql` | Классы автомобилей с лучшей средней позицией |
| `task_4.sql` | Автомобили лучше среднего результата в своём классе |
| `task_5.sql` | Классы с наибольшим количеством автомобилей со средней позицией больше 3.0 |

Примечание по `task_5.sql`:

По формальному условию используется строгое сравнение:

```sql
average_position > 3.0
```

Если нужно полностью совпасть с ожидаемым выводом задания, в подсчёте `low_position_count` может использоваться вариант:

```sql
average_position >= 3.0
```

потому что в ожидаемом выводе автомобиль со средней позицией ровно `3.0` учитывается в количестве автомобилей с низкой средней позицией.

---

## 3. Бронирование отелей

Папка:

```text
3_hotels_booking/
```

Таблицы:

- `Hotel`
- `Room`
- `Customer`
- `Booking`

Запуск:

```sql
\i 3_hotels_booking/table_schema.sql
\i 3_hotels_booking/data_script.sql
\i 3_hotels_booking/task_1.sql
\i 3_hotels_booking/task_2.sql
\i 3_hotels_booking/task_3.sql
```

Задачи:

| Файл | Описание |
|---|---|
| `task_1.sql` | Клиенты с более чем двумя бронированиями в разных отелях |
| `task_2.sql` | Клиенты с более чем двумя бронированиями и суммой бронирований больше 500 |
| `task_3.sql` | Категоризация отелей и определение предпочтений клиентов |

Примечание по `task_2.sql`:

В ожидаемом выводе `total_spent` считается как сумма цен номеров по бронированиям:

```sql
SUM(r.price)
```

без умножения на количество ночей.

Примечание по `task_3.sql`:

Категория отеля определяется по средней цене всех номеров отеля:

```sql
AVG(r.price)
```

Список отелей в ожидаемом выводе склеен без пробела после запятой:

```sql
STRING_AGG(hotel_name, ',' ORDER BY hotel_name)
```

---

## 4. Структура организации

Папка:

```text
4_organization_structure/
```

Таблицы:

- `Departments`
- `Roles`
- `Employees`
- `Projects`
- `Tasks`

Запуск:

```sql
\i 4_organization_structure/table_schema.sql
\i 4_organization_structure/data_script.sql
\i 4_organization_structure/task_1.sql
\i 4_organization_structure/task_2.sql
\i 4_organization_structure/task_3.sql
```

Задачи:

| Файл | Описание |
|---|---|
| `task_1.sql` | Рекурсивный вывод всех сотрудников, подчинённых Ивану Иванову |
| `task_2.sql` | То же самое, но с количеством задач и прямых подчинённых |
| `task_3.sql` | Поиск менеджеров с подчинёнными на всех уровнях |

В этих задачах используется:

```sql
WITH RECURSIVE
```

для обхода иерархии сотрудников.

---

## Проверка таблиц

После запуска `table_schema.sql` можно проверить, что таблицы создались:

```sql
\dt
```

Посмотреть структуру конкретной таблицы:

```sql
\d employees
\d booking
\d vehicle
```

---

## Проверка данных

Пример проверки количества строк:

```sql
SELECT COUNT(*) FROM Vehicle;
SELECT COUNT(*) FROM Cars;
SELECT COUNT(*) FROM Booking;
SELECT COUNT(*) FROM Employees;
```

---

## Повторный запуск

Если нужно пересоздать таблицы, сначала удалите старые.

Пример для первой темы:

```sql
DROP TABLE IF EXISTS Bicycle;
DROP TABLE IF EXISTS Motorcycle;
DROP TABLE IF EXISTS Car;
DROP TABLE IF EXISTS Vehicle;
```

Для таблиц со связями важно удалять их в правильном порядке: сначала зависимые таблицы, потом основные.

Можно также использовать:

```sql
DROP TABLE IF EXISTS table_name CASCADE;
```

---

## Особенности проекта

- Все решения представлены отдельными SQL-файлами.
- Каждый блок лежит в отдельной папке.
- Все запросы рассчитаны на PostgreSQL.
- В задачах используются:
  - `JOIN`
  - `GROUP BY`
  - `HAVING`
  - `UNION ALL`
  - `STRING_AGG`
  - `CASE`
  - `COALESCE`
  - `WITH`
  - `WITH RECURSIVE`
  - агрегатные функции `COUNT`, `AVG`, `SUM`, `MIN`

---
