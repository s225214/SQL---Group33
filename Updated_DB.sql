CREATE DATABASE LibrarySystem
USE LibrarySystem

DROP TABLE IF EXISTS Borrow;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Clients;
DROP TABLE IF EXISTS Authors;
DROP TABLE IF EXISTS Topics;
DROP TABLE IF EXISTS ReadingClub;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Sections;


CREATE TABLE Sections (
    Section VARCHAR(100),
    Location INT,
    PRIMARY KEY (Section, Location)
);

CREATE TABLE Employee (
	EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary INT
);

CREATE TABLE ReadingClub (
	ClubID INT PRIMARY KEY,
    Name VARCHAR(50),
    Section VARCHAR(100),
    Location INT,
    EmployeeID INT,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (Section, Location) REFERENCES Sections(Section, Location)
);

CREATE TABLE Topics (
	Topic VARCHAR (100) PRIMARY KEY
);

CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    Name VARCHAR(255),
    Birthdate DATE,
    Nationality VARCHAR(100)
);

CREATE TABLE Clients (
    ClientID INT PRIMARY KEY,
    Name VARCHAR(255),
    Email VARCHAR(255) UNIQUE,
    Phone VARCHAR(20),
    Birthdate DATE,
    Address TEXT
);

CREATE TABLE Books (
	BookID INT PRIMARY KEY,
    Title VARCHAR (100),
    AuthorID INT,
    PublicationDate DATE,
    Topic VARCHAR(100),
    Section VARCHAR(100),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    FOREIGN KEY (Topic) REFERENCES Topics(Topic),
    FOREIGN KEY (Section) REFERENCES Sections(Section)
);

CREATE TABLE Borrow (
	BorrowID INT PRIMARY KEY,
    ClientID INT,
    BookID INT,
    BorrowDate DATE,
    DueDate DATE,
    ReturnDate DATE,
    Fine INT,
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)    
);
