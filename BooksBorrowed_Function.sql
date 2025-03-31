--Function

DELIMITER //

CREATE FUNCTION TotalBooksBorrowed()
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE total_books INT;
    SELECT COUNT(*) INTO total_books
    FROM Borrows;
    RETURN total_books;
END//

DELIMITER ;

SELECT TotalBooksBorrowed();
