# Nashville Housing Data Cleaning

## Project Overview

This project focuses on cleaning raw Nashville housing data stored in the PortfolioProject database. The data cleaning process involves several SQL queries aimed at standardizing date formats, populating missing property addresses, breaking down addresses into individual columns, updating categorical variables, removing duplicates, and deleting unused columns.

## Data Cleaning Methods

### 1. Standardize Date Format

- Used `CONVERT` function to standardize the date format.
- Added a new column `SaleDateConverted` to store the converted date.

### 2. Populate Property Address Data

- Identified and populated missing property addresses by matching Parcel IDs from different records.
- Utilized `ISNULL` function to handle NULL values effectively.

### 3. Breaking out Address into Individual Columns

- Split the property address into separate columns for Address and City.
- Used `SUBSTRING`, `CHARINDEX`, `LEN`, `PARSENAME`, and `REPLACE` functions for data manipulation.

### 4. Change "Sold as Vacant" Field

- Replaced 'Y' and 'N' values in the "Sold as Vacant" field with 'Yes' and 'No' respectively using a `CASE` statement.

### 5. Remove Duplicates

- Identified and removed duplicate records based on specific columns using `ROW_NUMBER()` function.
- Deleted duplicate records by using a Common Table Expression (CTE) and a `DELETE` statement.

### 6. Delete Unused Columns

- Removed unused columns such as PropertyAddress, SaleDate, OwnerAddress, and TaxDistrict using the `ALTER TABLE` statement.

## Files Included

- **Nashville Housing Data for Data Cleaning.xlsx**: Contains the raw Nashville Housing Data
- **Nashville Housing Cleaned Data.xlsx**: Contains the cleaned Nashville Housing Data
- **Nashville Housing Data Cleaning with SQL.sql**: Contains all the SQL queries used for data cleaning.
- **README.md**: This file, providing an overview of the project and methods used for data cleaning.

## Usage

1. Ensure you have access to the PortfolioProject database containing the Nashville housing data.
2. Run the SQL queries in `Nashville Housing Data Cleaning with SQL.sql` in the correct sequence to clean the data effectively.
3. Monitor the execution of each query and verify the changes made to the dataset.
4. Once the data cleaning process is complete, the dataset should be ready for analysis or further processing.

## Contributors

- Divya B K

## Contact

For any questions or suggestions regarding this project, please contact divyabk54@gmail.com



