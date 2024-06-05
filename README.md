# Nashville Housing Data Cleaning Project

## Project Overview
This project aims to clean and prepare Nashville housing data for analysis using SQL. The dataset contains various property sale details, and the objective is to ensure data quality and consistency by performing several data cleaning tasks.

## Dataset
The dataset consists of two Excel files:
- `Nashville Housing Data for Data Cleaning (reuploaded).xlsx`
- `Nashville Housing Data for Data Cleaning.xlsx`

## Steps Performed
1. **View Initial Data**:
    - Query to display all records in the NashvilleHousing table.
2. **Standardize Date Format**:
    - Convert the `SaleDate` column to a standard date format.
    - Create and update a new column `SaleDateConverted` if the conversion in-place fails.
3. **Populate Missing Addresses**:
    - Identify and fill in missing `PropertyAddress` values by joining the table with itself based on `ParcelID`.
4. **Split Address into Components**:
    - Break out the `PropertyAddress` column into `Address`, `City`, and `State` columns.
5. **Remove Duplicates**:
    - Identify and delete duplicate records based on `ParcelID`.
6. **Drop Unused Columns**:
    - Remove columns that are no longer necessary after the cleaning process.
