# **Bookstore Database Specifications**

The **Bookstore** database is designed to manage information related to books, movies, people, rentals, invoices, newspapers, games, supplies, and purchases. The main purpose is to provide an efficient system for managing a bookstore, including rental services and purchases.

## **Database Structure**

### **Table: BOOK**
The "BOOK" table contains information about the books available in the bookstore.

| **ID_BOOK** | **TITLE** | **AUTHOR** | **GENRE** | **PRICE** | **TYPE** | **PAGE_COUNT** | **YEAR_PUBLISHED** | **DAYS_VALID** |
|-------------|-----------|------------|-----------|-----------|----------|----------------|--------------------|----------------|

### **Table: MOVIE**
The "MOVIE" table contains information about the movies available in the bookstore.

| **ID_MOVIE** | **TITLE** | **GENRE** | **DAYS_VALID** | **TYPE** | **YEAR_PUBLISHED** | **RATING** | **AUDIO_LANGUAGE** | **DIRECTOR** | **DURATION_MINUTES** | **ID_SUBTITLE** |
|--------------|-----------|-----------|----------------|----------|--------------------|------------|-------------------|-------------|--------------------|----------------|

### **Table: RENTAL**
The "RENTAL" table contains information about the rentals made in the bookstore.

| **ID_RENTAL** | **RENTAL_DATE** | **ID_PERSON** | **ID_BOOK** | **ID_MOVIE** |
|---------------|-----------------|--------------|-------------|--------------|

### **Table: INVOICE**
The "INVOICE" table contains information about invoices generated from purchases or rentals.

| **ID_INVOICE** | **INVOICE_DATE** | **INVOICE_TIME** | **DISCOUNT_GIVEN** | **TOTAL** |
|----------------|------------------|------------------|-------------------|----------|

### **Table: NEWSPAPER**
The "NEWSPAPER" table contains information about the newspapers available in the bookstore.

| **ID_NEWSPAPER** | **TITLE** | **GAMES** | **TYPE** | **PRICE** | **AGE_CATEGORY** | **GENRE** | **PAGE_COUNT** | **SIZE** | **STOCK** | **GIFT** | **EDITION** |
|------------------|-----------|----------|----------|----------|-----------------|----------|----------------|--------|---------|-------|-----------|

### **Table: GAME**
The "GAME" table contains information about games available in the bookstore.

| **ID_GAME** | **NAME** | **EDITION_TYPE** | **PLAYERS_COUNT** | **PEGI_RATING** | **COMPATIBILITY** | **TYPE** | **PRICE** | **STOCK** |
|-------------|----------|------------------|-------------------|-----------------|-------------------|----------|----------|----------|

### **Table: SUPPLY**
The "SUPPLY" table contains information about the supplies available in the bookstore.

| **ID_SUPPLY** | **NAME** | **BRAND** | **PRICE** | **STOCK** | **WEIGHT** |
|---------------|----------|-----------|----------|----------|------------|

### **Table: PURCHASE**
The "PURCHASE" table contains information about purchases made in the bookstore.

| **ID_PURCHASE** | **ID_PERSON** | **ID_NEWSPAPER** | **ID_SUPPLY** | **ID_GAME** | **ID_INVOICE** |
|-----------------|--------------|------------------|---------------|-------------|----------------|

## **Constraints**

- **BOOK**: `CK_TYPE` ensures the `TYPE` must be either 'audiobook' or 'ebook'.
- **SUBTITLE**: `SK_STYLE` ensures the `STYLE` must be 'BOLD', 'ITALIC', or 'BASIC'.
- **NEWSPAPER**: `ZK_TYPE` ensures the `TYPE` must be either 'MONOCHROME' or 'COLOR'.
- **GAME**: 
  - `JK_EDITION`: `EDITION_TYPE` must be 'STANDARD' or 'PREMIUM'.
  - `JK_PLAYERS_COUNT`: `PLAYERS_COUNT` must be 'SINGLE PLAYER', 'MULTIPLAYER', or 'CO-OP'.

## **Users**

1. User with read permissions (`SELECT`).
2. User with read and write permissions (`SELECT, INSERT, UPDATE, DELETE`).

## **Views**

- **View_PersonsUnder18**: Displays information about people under 18.
- **View_RentalDetails**: Provides complete rental details, including information about people, books, and movies.
- **View_RecentPurchasesDetails**: Shows detailed information about recent purchases.
- **View_BooksMoviesRented**: Shows detailed information about rented books and movies.

## **Procedures**

- **InsertRental**: Adds a new rental to the database.
- **InsertInvoice**: Adds a new invoice to the database.
- **InsertPurchase**: Adds a new purchase to the database.
- **UpdatePerson**: Updates a person’s information.
- **PersonRentalInfo**: Provides rental information for a specific person.
- **DeleteBook**: Deletes a book if it is not currently rented.

## **Triggers**

- **trg_InsertRental**: Triggered after a new rental is inserted, displaying information about the new rental.
- **trg_DeleteBook**: Triggered after a book is deleted, displaying information about the deleted book.
- **trg_CreateTable**: Triggered after a new table is created, displaying the name of the newly created table.
- **trg_DropTable**: Triggered after a table is dropped, displaying the name of the deleted table.

## **Cursors**

- **RentalInfo**: Iterates through the "RENTAL" table to display information about each rental.
- **NewspapersInfo**: Iterates through the "NEWSPAPER" table to display detailed information about each newspaper.
- **InvoicesInfo**: Iterates through the "INVOICE" table to display detailed information about each invoice.
- **PersonOrdersInfo**: Iterates through the "PURCHASE" table based on a person’s ID to display order information.

## **Indexes**

- **BOOK**: 
  - `IX_BOOK_TITLE`: Index on the `TITLE` column.
  - `IX_BOOK_AUTHOR_YEAR`: Composite index on the `AUTHOR` and `YEAR_PUBLISHED` columns.
- **RENTAL**: 
  - `IX_RENTAL_DATE`: Index on the `RENTAL_DATE` column.
- **PURCHASE**: 
  - `IX_PURCHASE_PERSON`: Index on the `ID_PERSON` column.
  - `IX_PURCHASE_INVOICE`: Index on the `ID_INVOICE` column.
- **PERSON**: Clustered index on the `ID_PERSON` column.
- **MOVIE**: Clustered index on the `ID_MOVIE` column.
- **Unique Constraint on `USERNAME`**: Ensures usernames in the "PERSON" table are unique.

## **Jobs**

- **CheckNewspaperStock**: A stored procedure that checks the stock of a specific newspaper.
- **CheckNewInvoices**: A stored procedure that checks the number of new invoices added in the last 24 hours.

## **Backup & Restore**

- **Backup**: Creates a complete backup of the "Bookstore" database.
- **Restore**: Restores the "Bookstore" database from a backup.
