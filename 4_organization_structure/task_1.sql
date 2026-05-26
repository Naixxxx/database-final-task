-- Решение первой задачи

WITH RECURSIVE employee_tree AS (
    -- Базовый шаг рекурсии:
    -- выбираем самого Ивана Иванова, то есть корневого сотрудника с EmployeeID = 1.
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    WHERE e.EmployeeID = 1

    UNION ALL

    -- Рекурсивный шаг:
    -- на каждой итерации находим сотрудников, у которых ManagerID
    -- равен EmployeeID уже найденного сотрудника
    -- Так получаем всех прямых и непрямых подчиненных Ивана Иванова
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    JOIN employee_tree et ON e.ManagerID = et.EmployeeID
),

project_agg AS (
    -- Собираем проекты для каждого сотрудника.
    -- Так как проект связан с отделом, считаем, что сотрудник относится
    -- к проектам своего отдела
    -- DISTINCT защищает от повторов, если они появятся
    SELECT e.EmployeeID, STRING_AGG(DISTINCT p.ProjectName, ', ' ORDER BY p.ProjectName) AS ProjectNames
    FROM Employees e
    JOIN Projects p ON e.DepartmentID = p.DepartmentID
    GROUP BY e.EmployeeID
),

task_agg AS (
    -- Собираем все задачи, назначенные конкретному сотруднику
    -- в одну строку через запятую
    -- Если задач нет, после LEFT JOIN в итоговом запросе будет NULL
    SELECT t.AssignedTo AS EmployeeID, STRING_AGG(t.TaskName, ', ' ORDER BY t.TaskName) AS TaskNames
    FROM Tasks t
    GROUP BY t.AssignedTo
)

SELECT et.EmployeeID, et.Name AS EmployeeName, et.ManagerID, d.DepartmentName, r.RoleName, pa.ProjectNames, ta.TaskNames
FROM employee_tree et
JOIN Departments d ON et.DepartmentID = d.DepartmentID
JOIN Roles r ON et.RoleID = r.RoleID
LEFT JOIN project_agg pa ON et.EmployeeID = pa.EmployeeID
LEFT JOIN task_agg ta ON et.EmployeeID = ta.EmployeeID

ORDER BY et.Name;
