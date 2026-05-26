-- Решение второй задачи

WITH RECURSIVE employee_tree AS (
    -- Базовый шаг рекурсии:
    -- выбираем самого Ивана Иванова с EmployeeID = 1
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    WHERE e.EmployeeID = 1

    UNION ALL

    -- Рекурсивный шаг:
    -- находим всех сотрудников, чей ManagerID равен EmployeeID
    -- уже найденного сотрудника
    -- Так получаем всех подчиненных Ивана Иванова на всех уровнях
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    JOIN employee_tree et ON e.ManagerID = et.EmployeeID
),

project_agg AS (
    -- Собираем проекты для каждого сотрудника
    -- В этой схеме проект связан с отделом, поэтому сотруднику
    -- соответствуют проекты его отдела
    -- DISTINCT убирает возможные повторы проектов
    SELECT e.EmployeeID, STRING_AGG(DISTINCT p.ProjectName, ', ' ORDER BY p.ProjectName) AS ProjectNames
    FROM Employees e
    JOIN Projects p ON e.DepartmentID = p.DepartmentID
    GROUP BY e.EmployeeID
),

task_agg AS (
    -- Собираем задачи, назначенные каждому сотруднику
    -- STRING_AGG объединяет названия задач в одну строку через запятую
    -- COUNT считает общее количество задач сотрудника
    SELECT
        t.AssignedTo AS EmployeeID,
        STRING_AGG(t.TaskName, ', ' ORDER BY t.TaskName) AS TaskNames,
        COUNT(t.TaskID) AS TotalTasks
    FROM Tasks t
    GROUP BY t.AssignedTo
),

subordinate_count AS (
    -- Считаем только прямых подчиненных.
    -- По условию задачи 2 подчиненные подчиненных здесь не учитываются.
    SELECT
        ManagerID AS EmployeeID,
        COUNT(*) AS TotalSubordinates
    FROM Employees
    WHERE ManagerID IS NOT NULL
    GROUP BY ManagerID
)

SELECT
    et.EmployeeID,
    et.Name AS EmployeeName,
    et.ManagerID,
    d.DepartmentName,
    r.RoleName,
    pa.ProjectNames,
    ta.TaskNames,
    COALESCE(ta.TotalTasks, 0) AS TotalTasks,
    COALESCE(sc.TotalSubordinates, 0) AS TotalSubordinates
FROM employee_tree et
JOIN Departments d ON et.DepartmentID = d.DepartmentID
JOIN Roles r ON et.RoleID = r.RoleID
LEFT JOIN project_agg pa ON et.EmployeeID = pa.EmployeeID
LEFT JOIN task_agg ta ON et.EmployeeID = ta.EmployeeID
LEFT JOIN subordinate_count sc ON et.EmployeeID = sc.EmployeeID

ORDER BY et.Name;
