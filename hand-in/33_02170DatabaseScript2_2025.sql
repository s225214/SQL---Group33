DROP PROCEDURE IF EXISTS register_borrow;
DROP TRIGGER IF EXISTS update_stock_on_return;

-- QUERIES

-- FUNCTION

-- PROCEDURE
DELIMITER //
CREATE PROCEDURE register_borrow(
	IN in_book_id INT,
	IN in_client_id INT)
BEGIN
	DECLARE local_stock INT DEFAULT 0;
	
	SELECT stock INTO local_stock FROM Book WHERE book_id = in_book_id;

	IF local_stock>0 THEN
	INSERT INTO Borrows (client_id, book_id, due_date, return_date)
        VALUES (in_client_id, in_book_id, CURDATE() + INTERVAL 30 DAY, null);
	UPDATE Book SET stock = stock-1 WHERE book_id = in_book_id;
	ELSE
	SIGNAL SQLSTATE '45000'
	SET MYSQL_ERRNO= 10001, MESSAGE_TEXT = 'Book is out of stock.';
	END IF;
END //
DELIMITER ;

-- TRIGGER
DELIMITER //
CREATE TRIGGER update_stock_on_return
AFTER UPDATE ON Borrows
FOR EACH ROW
BEGIN
    IF OLD.return_date IS NULL AND NEW.return_date IS NOT NULL THEN
        UPDATE Book
        SET stock = stock + 1
        WHERE book_id = NEW.book_id;
    END IF;
END//
DELIMITER ;

-- DELETE 
DELETE FROM Borrows
WHERE return_date IS NOT NULL
AND due_date < CURDATE() - INTERVAL 10 YEAR;

-- UPDATE 
UPDATE Book AS b
SET b.stock = CASE 
                WHEN b.stock <= 4 THEN b.stock * 1.25
                ELSE b.stock * 1.15
              END
WHERE b.book_id IN (
    SELECT br.book_id
    FROM Borrows AS br
    WHERE br.due_date > CURDATE() - INTERVAL 1 YEAR
    GROUP BY br.book_id
    HAVING COUNT(br.book_id) > 2
);
