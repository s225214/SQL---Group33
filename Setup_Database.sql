CREATE DATABASE LibrarySystem;
USE LibrarySystem;

DROP TABLE IF EXISTS Works;
DROP TABLE IF EXISTS Discusses;
DROP TABLE IF EXISTS Participates;
DROP TABLE IF EXISTS Borrows;
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Clients;
DROP TABLE IF EXISTS Author;
DROP TABLE IF EXISTS ReadingClub;
DROP TABLE IF EXISTS Topic;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Section;


CREATE TABLE Section (
    section_name VARCHAR(50) PRIMARY KEY,
    section_location INT
);

CREATE TABLE Employee (
	emp_id INT AUTO_INCREMENT PRIMARY KEY ,
    emp_name VARCHAR(50),
    salary INT
);

CREATE TABLE Topic (
	topic_name VARCHAR (50) PRIMARY KEY
);

CREATE TABLE ReadingClub (
	club_id INT AUTO_INCREMENT PRIMARY KEY ,
    club_name VARCHAR(50),
    day_happening DATE,
    club_responsible INT,
    club_topic VARCHAR(50),
    FOREIGN KEY (club_responsible) REFERENCES Employee(emp_id) ON DELETE SET NULL,
    FOREIGN KEY (club_topic) REFERENCES Topic(topic_name) ON DELETE SET NULL
);


CREATE TABLE Author (
    author_id INT AUTO_INCREMENT PRIMARY KEY ,
    author_name VARCHAR(70) NOT NULL,
    birthdate DATE,
    nationality VARCHAR(30)
);

CREATE TABLE Clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    client_name VARCHAR(40),
    client_email VARCHAR(70) UNIQUE NOT NULL,
    client_phone VARCHAR(20),
    client_birthdate DATE NOT NULL,
    client_address VARCHAR(120) NOT NULL
);

CREATE TABLE Book (
	book_id INT AUTO_INCREMENT PRIMARY KEY,
    book_title VARCHAR (100) NOT NULL,
    book_author INT,
    publication_date DATE,
    topic VARCHAR(100),
    section VARCHAR(100),
    stock INT,
    FOREIGN KEY (book_author) REFERENCES Author(author_id) ON DELETE SET NULL,
    FOREIGN KEY (topic) REFERENCES Topic(topic_name) ON DELETE SET NULL,
    FOREIGN KEY (section) REFERENCES Section(section_name) ON DELETE SET NULL
);
CREATE TABLE Borrows ( 
	client_id INT,
    book_id INT,
    due_date DATE,
    return_date DATE,
    PRIMARY KEY (client_id,book_id,due_date),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)   
);


CREATE TABLE Participates (
    client_id INT,
    club_id INT,
    PRIMARY KEY (client_id, club_id),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (club_id) REFERENCES ReadingClub(club_id) ON DELETE CASCADE    
);

CREATE TABLE Discusses (
    book_id INT,
    club_id INT,
    PRIMARY KEY (book_id, club_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id),
    FOREIGN KEY (club_id) REFERENCES ReadingClub(club_id) ON DELETE CASCADE    
);


CREATE TABLE Works (
    section_name VARCHAR(50),
    emp_id INT,
    PRIMARY KEY (emp_id, section_name),
    FOREIGN KEY (section_name) REFERENCES Section(section_name) ON DELETE CASCADE,
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id) ON DELETE CASCADE    
);


INSERT INTO Author (author_name, birthdate, nationality)
VALUES 
('Unknown', NULL, NULL),
('Jane Austen', '1775-12-16', 'British'),
('George Orwell', '1903-06-25', 'British'),
('Harper Lee', '1926-04-28', 'American'),
('Herman Melville', '1819-08-01', 'American'),
('F. Scott Fitzgerald', '1896-09-24', 'American'),
('Leo Tolstoy', '1828-09-09', 'Russian'),
('J.D. Salinger', '1919-01-01', 'American'),
('Mary Shelley', '1797-08-30', 'British'),
('Suzanne Collins', '1962-08-10', 'American'),
('J.K. Rowling', '1965-07-31', 'British'),
('Rick Riordan', '1964-06-05', 'American'),
('E.B. White', '1899-07-11', 'American'),
('Eric Carle', '1929-06-25', 'American'),
('Maurice Sendak', '1928-06-10', 'American'),
('Miguel de Cervantes', '1547-09-29', 'Spanish'),
('Homer', NULL, 'Greek'),
('Dante Alighieri', '1265-05-21', 'Italian'),
('Paulo Coelho','1947-08-24','Brasilian');

INSERT INTO Topic (topic_name)
VALUES 
('Romance'),
('Dystopian'),
('Drama'),
('Adventure'),
('Classic'),
('Historical'),
('Coming-of-Age'),
('Picaresque'),
('Children'),
('Epic'),
('Fantasy'),
('Horror');

INSERT INTO Section (section_name, section_location)
VALUES 
('Adults', 1),
('Teens', 2),
('Kids', 3),
('Antiques', 4),
('Newspapers',2);


INSERT INTO Book (book_title, book_author, publication_date, topic, section, stock)
VALUES 
('Pride and Prejudice', 2, '1813-01-28', 'Romance', 'Adults', 5),
('1984', 3, '1949-06-08', 'Dystopian', 'Adults', 7),
('To Kill a Mockingbird', 4, '1960-07-11', 'Drama', 'Adults', 8),
('Moby-Dick', 5, '1851-10-18', 'Adventure', 'Teens', 4),
('The Great Gatsby', 6, '1925-04-10', 'Classic', 'Adults', 6),
('War and Peace', 7, '1869-01-01', 'Historical', 'Adults', 3),
('The Catcher in the Rye', 8, '1951-07-16', 'Coming-of-Age', 'Adults', 9),
('Frankenstein', 9, '1818-01-01', 'Horror', 'Adults', 5),
('The alchemist',18,'1988-02-14','Adventure','Adults',1),
('The Hunger Games', 10, '2008-09-14', 'Dystopian', 'Teens', 10),
('Harry Potter and the Sorcerer\'s Stone', 11, '1997-06-26', 'Fantasy', 'Teens', 12),
('Percy Jackson & The Olympians: The Lightning Thief', 12, '2005-06-28', 'Fantasy', 'Teens', 9),
('Charlotte\'s Web', 13, '1952-10-15', 'Children', 'Kids', 15),
('The Very Hungry Caterpillar', 14, '1969-06-03', 'Children', 'Kids', 20),
('Where the Wild Things Are', 15, '1963-04-09', 'Children', 'Kids', 18),
('Don Quixote', 16, '1605-01-16', 'Classic', 'Antiques', 3),
('The Iliad', 17, '762-01-01', 'Epic', 'Antiques', 2),
('The Divine Comedy', 18, '1320-01-01', 'Classic', 'Antiques', 4),
('El Lazarillo de Tormes', 1, '1249-03-04', 'Picaresque', 'Antiques', 1);




INSERT INTO Employee (emp_name, salary)
VALUES 
('Alice Johnson', 45000),
('Bob Smith', 42000),
('Charlie Brown', 40000),
('David Williams', 38000),
('Emma Davis', 47000);

INSERT INTO Clients (client_name, client_email, client_phone, client_birthdate, client_address)
VALUES 
('John Doe', 'johndoe@example.com', '123-456-7890', '1990-05-15', '123 Elm Street'),
('Jane Smith', 'janesmith@example.com', '987-654-3210', '1985-10-20', '456 Oak Avenue'),
('Michael Brown', 'michaelb@example.com', '555-123-6789', '2000-07-30', '789 Pine Road'),
('Arturo Cortes', 'artculos@gmail.com','123456','2004-03-19','19 Malaga');

INSERT INTO Borrows (client_id, book_id, due_date, return_date)
VALUES 
(1, 1, '2025-04-01', NULL),
(2, 3, '2025-03-28', '2025-03-18'),
(3, 5, '2025-04-10', NULL),
(4,19, '2004-03-19', NULL)
;

INSERT INTO ReadingClub (club_name, day_happening, club_responsible, club_topic)
VALUES 
('Classic Book Club', '2025-04-05', 1, 'Classic'),
('Fantasy Lovers', '2025-04-12', 2, 'Fantasy'),
('Dystopian Discussions', '2025-04-19', 3, 'Dystopian');

INSERT INTO Participates (client_id, club_id)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4,1);

INSERT INTO Discusses (book_id, club_id)
VALUES 
(1, 1),
(5, 2),
(16,1),
(2, 3);

INSERT INTO Works (section_name, emp_id)
VALUES 
('Adults', 1),
('Teens', 2),
('Kids', 3),
('Antiques', 4),
('Newspapers', 5);

