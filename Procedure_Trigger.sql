DROP PROCEDURE IF EXISTS register_borrow;
DROP TRIGGER IF EXISTS update_stock_on_return;

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

SELECT * FROM Borrows; -- before
SELECT book_id, book_title, section, stock FROM Book WHERE section = 'Antiques';

CALL register_borrow(19, 1); -- 19 has only one copy; should drop to 0

SELECT * FROM Borrows; -- after
SELECT book_id, book_title, section, stock FROM Book WHERE section = 'Antiques';

CALL register_borrow(19, 1); -- 19 has zero copies; should return error

UPDATE Borrows SET return_date = CURDATE() WHERE book_id = 19 AND client_id = 1;

SELECT * FROM Borrows;
SELECT book_id, book_title, section, stock FROM Book WHERE section = 'Antiques';



