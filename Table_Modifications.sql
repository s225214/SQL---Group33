DELETE FROM Borrows
WHERE return_date IS NOT NULL
AND due_date < CURDATE() - INTERVAL 10 YEAR;

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
