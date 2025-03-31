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