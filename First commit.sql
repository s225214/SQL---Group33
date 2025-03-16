CREATE DATABASE Library
USE Library

CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    Name VARCHAR(255),
    Email VARCHAR(255) UNIQUE,
    Phone VARCHAR(20),
    Address TEXT
);

CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    Name VARCHAR(255),
    Birthdate DATE,
    Nationality VARCHAR(100)
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    Name VARCHAR(100)
);

CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(255),
    AuthorID INT,
    CategoryID INT,
    Stock INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Borrow (
    BorrowID INT PRIMARY KEY,
    MemberID INT,
    BookID INT,
    BorrowDate DATE,
    DueDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

CREATE TABLE Returns (
    ReturnID INT PRIMARY KEY,
    BorrowID INT,
    ReturnDate DATE,
    FineAmount DECIMAL(5,2),
    FOREIGN KEY (BorrowID) REFERENCES Borrow(BorrowID)
);

CREATE TABLE Fines (
    FineID INT PRIMARY KEY,
    MemberID INT,
    Amount DECIMAL(5,2),
    Status VARCHAR(50),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

INSERT INTO Members VALUES (1, 'Alice Johnson', 'alice@mail.com', '1234567890', '123 Elm St');
INSERT INTO Authors VALUES (1, 'J.K. Rowling', '1965-07-31', 'British');
INSERT INTO Categories VALUES (1, 'Fantasy');
INSERT INTO Books VALUES (1, 'Harry Potter', 1, 1, 5);
INSERT INTO Borrow VALUES (1, 1, 1, '2025-02-01', '2025-02-15');


#View all borrowed books
SELECT Members.Name, Books.Title, Borrow.BorrowDate, Borrow.DueDate
FROM Borrow
JOIN Members ON Borrow.MemberID = Members.MemberID
JOIN Books ON Borrow.BookID = Books.BookID;

#View overdue books
SELECT Members.Name, Books.Title, Borrow.DueDate
FROM Borrow
JOIN Members ON Borrow.MemberID = Members.MemberID
JOIN Books ON Borrow.BookID = Books.BookID
WHERE Borrow.DueDate < CURDATE();

#Reduce Stock When a Book is Borrowed
CREATE TRIGGER ReduceStock AFTER INSERT ON Borrow
FOR EACH ROW
UPDATE Books SET Stock = Stock - 1 WHERE BookID = NEW.BookID;
