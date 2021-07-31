-- Cleaning the data
Select  
*From [Data Cleaning set]..DataCleansing

-- Removing the inconsistent time format in the SaleDate section
Select  SaleDateConverted, CONVERT(Date,SaleDate)
From [Data Cleaning set]..DataCleansing

ALTER table DataCleansing
ADD SaleDateConverted Date;

UPDATE DataCleansing
SET SaleDateConverted = CONVERT(Date,SaleDate)	

--Populate Property Address Null values with corressponding row values
Select PropertyAddress
From [Data Cleaning set]..DataCleansing
WHERE PropertyAddress is null

Select 	row1.ParcelID, row2.ParcelID, row1.PropertyAddress, row2.PropertyAddress, ISNULL(row1.PropertyAddress,row2.PropertyAddress)
From [Data Cleaning set]..DataCleansing row1
JOIN [Data Cleaning set]..DataCleansing row2
   on row1.ParcelID = row2.ParcelID
   AND row1.[UniqueID] <> row2.[UniqueID]
   WHERE row1.PropertyAddress is null

UPDATE row1
SET PropertyAddress = ISNULL(row1.PropertyAddress,row2.PropertyAddress)
From [Data Cleaning set]..DataCleansing row1
JOIN [Data Cleaning set]..DataCleansing row2
   on row1.ParcelID = row2.ParcelID
   AND row1.[UniqueID] <> row2.[UniqueID]
   WHERE row1.PropertyAddress is null

--Dividing the address into sub address
SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
From [Data Cleaning set]..DataCleansing

ALTER table DataCleansing
ADD Street NVARCHAR(255);

UPDATE DataCleansing
SET Street = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER table DataCleansing
ADD City NVARCHAR(255);

UPDATE DataCleansing
SET City = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))	

SELECT * FROM [Data Cleaning set]..DataCleansing

--Split Owner Address using PARSE 
SELECT OwnerAddress
FROM [Data Cleaning set]..DataCleansing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM [Data Cleaning set]..DataCleansing

ALTER table DataCleansing
ADD OwnerStreet NVARCHAR(255);

UPDATE DataCleansing
SET OwnerStreet = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER table DataCleansing
ADD OwnerCity NVARCHAR(255);

UPDATE DataCleansing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER table DataCleansing
ADD OwnerState NVARCHAR(255);

UPDATE DataCleansing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

SELECT * FROM [Data Cleaning set]..DataCleansing
