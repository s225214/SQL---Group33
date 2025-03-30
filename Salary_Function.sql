DELIMITER // 
CREATE FUNCTION EmpSalary(p_emp_id INT)
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE emp_salary DECIMAL(10,2);
    SELECT IFNULL(salary, 0.00) INTO emp_salary
    FROM Employee 
    WHERE emp_id = p_emp_id
    LIMIT 1;
    
    RETURN emp_salary;
END// 
DELIMITER ;

SELECT EmpSalary(5);
