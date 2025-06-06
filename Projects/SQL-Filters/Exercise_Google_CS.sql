SELECT device_id, operating_system
FROM machines;


SELECT device_id, operating_system
FROM machines 
WHERE operating_system = 'OS 2';

SELECT * 
FROM employees 
WHERE department = 'Finance';
 
SELECT * 
FROM employees 
WHERE department = 'Sales';

SELECT *
FROM employees 
WHERE office ='South-109';

SELECT *
FROM employees
WHERE office LIKE 'South-%';

SELECT *
FROM employees
WHERE office = 'South-109';

# Operators for JOINS

SELECT * 
FROM machines 
INNER JOIN employees ON machines.device_id = employees.device_id;

SELECT * 
FROM machines 
INNER JOIN employees ON machines.device_id = employees.device_id;

SELECT * 
FROM machines 
LEFT JOIN employees ON machines.device_id = employees.device_id;

SELECT *
FROM machines 
RIGHT JOIN employees ON machines.device_id = employees.device_id;

SELECT * 
FROM employees 
INNER JOIN log_in_attempts ON employees.username = log_in_attempts.username;

--### If the security team at SecureCorp suspects a data breach , one of their first steps would be to analyze database activity logs using SQL queries. These logs often contain valuable information about who accessed what data, when, and how — which is crucial for identifying unauthorized access , data exfiltration , or other suspicious behaviors.###
--###🧩 Step-by-Step SQL Analysis for Breach Detection
--1. Identify all database activity during the suspected breach window###

SELECT *
FROM database_activity_logs
WHERE timestamp BETWEEN '2025-04-04 22:00:00' AND '2025-04-05 06:00:00';

--2. Check for unusual access patterns, such as logins from unfamiliar IP addresses or access to sensitive data by unauthorized users.
SELECT *
FROM database_activity_logs 
WHERE timestamp BETWEEN '2025-04-04 22:00:00' AND '2025-04-05 06:00:00'

AND (ip_address NOT IN (SELECT DISTINCT ip_address FROM authorized_ips)
OR username NOT IN (SELECT DISTINCT username FROM authorized_users));   

--3. Look for failed login attempts that could indicate brute-force attacks or unauthorized access attempts.
SELECT *
FROM log_in_attempts
WHERE timestamp BETWEEN '2025-04-04 22:00:00' AND '2025-04-05 06:00:00'
AND status = 'failed';
--4. Analyze data exfiltration attempts by checking for large data exports or downloads during the breach window.
SELECT *    
FROM data_exports
WHERE timestamp BETWEEN '2025-04-04 22:00:00' AND '2025-04-05 06:00:00'
AND size > 1000000; -- Assuming size is in bytes and 1MB is the threshold for large exports
--5. Review changes to sensitive data, such as modifications to user permissions or access controls.
SELECT *
FROM data_changes
WHERE timestamp BETWEEN '2025-04-04 22:00:00' AND '2025-04-05 06:00:00'
AND (change_type = 'permission_change' OR change_type = 'access_control_change');
--6. Identify any anomalies in the data, such as unexpected changes in user roles or access levels.
SELECT *
FROM user_roles
WHERE timestamp BETWEEN '2025-04-04 22:00:00' AND '2025-04-05 06:00:00'
AND (role_change = 'unexpected' OR access_level_change = 'unexpected');
--7. Generate a report summarizing the findings, including any suspicious activities, unauthorized access attempts, and potential data breaches.
SELECT 
    username, 
    COUNT(*) AS failed_attempts
FROM log_in_attempts
WHERE timestamp BETWEEN '2025-04-04 22:00:00' AND '2025-04-05 06:00:00'
AND status = 'failed'
GROUP BY username
ORDER BY failed_attempts DESC;
SELECT 
    username, 
    COUNT(*) AS data_exports
FROM data_exports
WHERE timestamp BETWEEN '2025-04-04 22:00:00' AND '2025-04-05 06:00:00'
GROUP BY username
ORDER BY data_exports DESC;
SELECT 
    username, 
    COUNT(*) AS data_changes
FROM data_changes
WHERE timestamp BETWEEN '2025-04-04 22:00:00' AND '2025-04-05 06:00:00'
GROUP BY username
ORDER BY data_changes DESC;
SELECT 
    username, 
    COUNT(*) AS role_changes
FROM user_roles
WHERE timestamp BETWEEN '2025-04-04 22:00:00' AND '2025-04-05 06:00:00'
GROUP BY username
ORDER BY role_changes DESC;
SELECT *
FROM database_activity_logs
WHERE timestamp BETWEEN '2025-04-04 22:00:00' AND '2025-04-05 06:00:00'
AND (ip_address NOT IN (SELECT DISTINCT ip_address FROM authorized_ips)
OR username NOT IN (SELECT DISTINCT username FROM authorized_users))
AND (status = 'failed' OR size > 1000000 OR change_type IN ('permission_change', 'access_control_change') OR role_change = 'unexpected' OR access_level_change = 'unexpected');
-- This query combines all the findings into a comprehensive report for the security team to review.