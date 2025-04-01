DROP PROCEDURE IF EXISTS register_borrow;
DROP TRIGGER IF EXISTS update_stock_on_return;
DROP FUNCTION IF EXISTS TotalBooksBorrowed;

-- QUERIES

SELECT club_name 
FROM ReadingClub NATURAL JOIN Participates 
WHERE client_id IN 
(SELECT client_id FROM Clients WHERE 
client_name LIKE '%Michael%');

SELECT club_name, COUNT(*) AS withdrawn_books
FROM Participates NATURAL JOIN Borrows NATURAL JOIN ReadingClub 
WHERE (return_date IS NULL) GROUP BY club_name;


(SELECT book_title FROM Book WHERE book_id IN (SELECT book_id FROM HasTopic WHERE topic_name = 'Romance'))
UNION
(SELECT book_title FROM Book WHERE section = 'Teens' AND book_id IN (SELECT book_id FROM HasTopic WHERE topic_name = 'Dystopian'));

-- FUNCTION

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

-- PROCEDURE
DROP PROCEDURE IF EXISTS register_borrow;
DROP TRIGGER IF EXISTS update_stock_on_return;

DELIMITER //
CREATE PROCEDURE register_borrow(
	IN in_book_id INT,
	IN in_client_id INT,
    OUT out_message VARCHAR(30),
    OUT out_code INT) -- -1 book not found, 0 success, 1 not available
BEGIN
	-- variable declaration
	DECLARE local_stock INT;
    SET local_stock = (SELECT stock FROM Book WHERE book_id = in_book_id);
	
    IF local_stock IS NULL THEN
		SET out_message = 'Book ID could not be found.';
        SET out_code = -1;
	ELSEIF local_stock>0 THEN
		INSERT INTO Borrows (client_id, book_id, due_date, return_date)
        VALUES (in_client_id, in_book_id, CURDATE() + INTERVAL 30 DAY, null);
		UPDATE Book SET stock = stock-1 WHERE book_id = in_book_id;
        SET out_message = 'Book borrowing was successful.';
        SET out_code = 0;
	ELSE
        SET out_message = 'Book is out of stock.';
        SET out_code = 1;
	END IF;
END //
DELIMITER ;

-- Tables before procedure
SELECT * FROM Borrows; 
SELECT book_id, book_title, section, stock FROM Book WHERE section = 'Antiques';

-- Apply procedure
CALL register_borrow(19, 1, @out_m, @out_c); -- 19 has only one copy; should drop to 0

SELECT @out_m, @out_c;
SELECT * FROM Borrows;
SELECT book_id, book_title, section, stock FROM Book WHERE section = 'Antiques';

CALL register_borrow(19, 1, @out_m, @out_c); -- 19 has zero copies; should return code 1

SELECT @out_m, @out_c;

CALL register_borrow(100,1,@out_m ,@out_c); -- 100 does not exist; should return code -1
SELECT @out_m, @out_c;

-- Trigger
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

UPDATE Borrows SET return_date = CURDATE() WHERE book_id = 19 AND client_id = 1;

-- See result of trigger on tables
SELECT * FROM Borrows;
SELECT book_id, book_title, section, stock FROM Book WHERE section = 'Antiques';

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
