-- Решение третьей задачи

WITH RECURSIVE subordinate_tree AS (
    -- Базовый шаг рекурсии:
    -- для каждого сотрудника, у которого есть менеджер
    -- создаем пару руководитель -> прямой подчиненный
    -- RootManagerID это сотрудник, для которого дальше будем считать
    -- всех подчиненных на всех уровнях
    SELECT e.ManagerID AS RootManagerID, e.EmployeeID AS SubordinateID
    FROM Employees e
    WHERE e.ManagerID IS NOT NULL

    UNION ALL

    -- Рекурсивный шаг:
    -- ищем подчиненных уже найденных подчиненных
    -- RootManagerID при этом сохраняется прежним, чтобы все найденные
    -- сотрудники относились к изначальному руководителю
    SELECT st.RootManagerID, e.EmployeeID AS SubordinateID
    FROM subordinate_tree st
    JOIN Employees e ON e.ManagerID = st.SubordinateID
),

subordinate_count AS (
    -- Считаем общее количество подчиненных для каждого руководителя
    -- Здесь учитываются не только прямые подчиненные
    -- но и подчиненные подчиненных на всех уровнях
    SELECT
        RootManagerID AS EmployeeID,
        COUNT(*) AS TotalSubordinates
    FROM subordinate_tree
    GROUP BY RootManagerID
),

project_agg AS (
    -- Собираем проекты для каждого сотрудника
    -- Проекты связаны с отделами, поэтому сотрудник относится
    -- к проектам своего отдела
    -- DISTINCT убирает возможные повторы проектов
    SELECT e.EmployeeID, STRING_AGG(DISTINCT p.ProjectName, ', ' ORDER BY p.ProjectName) AS ProjectNames
    FROM Employees e
    JOIN Projects p ON e.DepartmentID = p.DepartmentID
    GROUP BY e.EmployeeID
),

task_agg AS (
    -- Собираем задачи, назначенные каждому сотруднику
    -- в одну строку через запятую
    -- Если задач нет, после LEFT JOIN в итоговом запросе будет NULL
    SELECT t.AssignedTo AS EmployeeID, STRING_AGG(t.TaskName, ', ' ORDER BY t.TaskName) AS TaskNames
    FROM Tasks t
    GROUP BY t.AssignedTo
)

SELECT e.EmployeeID, e.Name AS EmployeeName, e.ManagerID, d.DepartmentName, r.RoleName, pa.ProjectNames, ta.TaskNames, sc.TotalSubordinates
FROM Employees e
JOIN Roles r ON e.RoleID = r.RoleID
JOIN Departments d ON e.DepartmentID = d.DepartmentID
LEFT JOIN project_agg pa ON e.EmployeeID = pa.EmployeeID
LEFT JOIN task_agg ta ON e.EmployeeID = ta.EmployeeID
JOIN subordinate_count sc ON e.EmployeeID = sc.EmployeeID
WHERE r.RoleName = 'Менеджер'
  AND sc.TotalSubordinates > 0

ORDER BY e.Name;
