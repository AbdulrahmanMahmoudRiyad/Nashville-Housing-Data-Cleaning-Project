
/*
Cleaning Data in SQL Queries
*/

/* View all records from NashvilleHousing */
SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing;

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

-- Convert and view the SaleDate to standard date format
SELECT CONVERT(Date, SaleDate) AS ConvertedSaleDate
FROM PortfolioProject.dbo.NashvilleHousing;

-- Update the SaleDate column to standard date format
UPDATE PortfolioProject.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate);

-- If the above update doesn't work, add a new column and update it
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD SaleDateConverted Date;

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

-- View all records ordered by ParcelID
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
ORDER BY ParcelID;

-- Find and fill missing PropertyAddress by joining with the same table
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
       ISNULL(a.PropertyAddress, b.PropertyAddress) AS FilledPropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    ON a.ParcelID = b.ParcelID
   AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL;

-- Update missing PropertyAddress using the above logic
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    ON a.ParcelID = b.ParcelID
   AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL;

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

-- View the PropertyAddress to understand its structure
SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing;

-- Split PropertyAddress into Address, City, and State
SELECT 
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, CHARINDEX(',', PropertyAddress, CHARINDEX(',', PropertyAddress) + 1) - CHARINDEX(',', PropertyAddress) - 1) AS City,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress, CHARINDEX(',', PropertyAddress) + 1) + 1, LEN(PropertyAddress)) AS State
FROM PortfolioProject.dbo.NashvilleHousing;

-- Add new columns for Address, City, and State
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD Address NVARCHAR(255), 
    City NVARCHAR(255), 
    State NVARCHAR(255);

-- Update the new columns with split values from PropertyAddress
UPDATE PortfolioProject.dbo.NashvilleHousing
SET 
    Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1),
    City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, CHARINDEX(',', PropertyAddress, CHARINDEX(',', PropertyAddress) + 1) - CHARINDEX(',', PropertyAddress) - 1),
    State = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress, CHARINDEX(',', PropertyAddress) + 1) + 1, LEN(PropertyAddress));

--------------------------------------------------------------------------------------------------------------------------

-- Removing Duplicates

-- View records to identify duplicates
SELECT *, 
       ROW_NUMBER() OVER(PARTITION BY ParcelID ORDER BY [UniqueID]) AS row_num
FROM PortfolioProject.dbo.NashvilleHousing;

-- Delete duplicate records based on ParcelID
WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY ParcelID ORDER BY [UniqueID]) AS row_num
    FROM PortfolioProject.dbo.NashvilleHousing
)
DELETE FROM RowNumCTE
WHERE row_num > 1;

--------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

-- View all records before dropping columns
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing;

-- Drop unnecessary columns
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;
