# JDBC Bonus Project

This project is a simple Java application that uses **JDBC (Java Database Connectivity)** to connect to a MySQL database. It demonstrates how to perform basic database operations like **inserting**, **reading**, **updating**, and **deleting records** using the **DAO (Data Access Object)** design pattern.

---

## Why DataAccessObject Pattern?

The **DAO pattern** helps in separating:
- Business logic (Main class)
- From database logic (DAO classes)

### Benefits:
- Cleaner, modular code
- Easy maintenance and testing
- Reusability of database methods

---

## How to run this code?

To run the .jar file:

**Windows:**
java -cp "jdbcBonus.jar;lib/mysql-connector-j-9.4.0.jar" Main

text

**Linux/Mac:**
java -cp "jdbcBonus.jar:lib/mysql-connector-j-9.4.0.jar" Main

text

---

## Database Connection

We're using the **MySQL JDBC driver** (`mysql-connector-j-9.4.0.jar`) to connect to a local MySQL database.

Connection is established using:

Connection conn = DriverManager.getConnection(url, username, password);

text

### Connection Details:
- **Database:** MySQL
- **Driver:** `mysql-connector-j-9.4.0.jar`
- **URL Format:** `jdbc:mysql://localhost:3306/database_name`

---

## Prerequisites

1. **Java 8+** installed
2. **MySQL Server** running locally
3. **Database created** with required tables
4. **MySQL JDBC Driver** (`mysql-connector-j-9.4.0.jar`) in the `lib/` folder

---

## Project Structure

project/
├── jdbcBonus.jar
├── lib/
│ └── mysql-connector-j-9.4.0.jar
├── src/
│ ├── Main.java
│ ├── dao/
│ │ └── [DAO classes]
│ └── model/
│ └── [Model classes]
└── README.md

text

---

## Features

- CRUD operations using JDBC
- DAO design pattern implementation
- Connection pooling (optional)
- PreparedStatement for SQL injection prevention
- Proper resource management with try-with-resources

---

## Getting Started

1. Clone the repository
2. Ensure MySQL is running
3. Update database credentials in the configuration
4. Compile and run using the commands above