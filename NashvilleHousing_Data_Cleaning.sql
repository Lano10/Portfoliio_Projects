/*

Cleaning Data in SQL Queries

*/

----------------------------------------------------------------------------------------------------------------------------------------

-- Data Format Standardization

select SaleDate, SaleDateConverted, CONVERT(Date,SaleDate) 
from PortfolioProject.dbo.NashvilleHousing;

--Update NashvilleHousing
--SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

----------------------------------------------------------------------------------------------------------------------------------------

--Populating data for Property Address if null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

----------------------------------------------------------------------------------------------------------------------------------------

--Breaking out Address into columns(Address, City, State)

Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertyListingAddress Nvarchar(255);

ALTER TABLE NashvilleHousing
Add PropertyListingCity Nvarchar(255);

Update NashvilleHousing
SET PropertyListingAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Update NashvilleHousing
SET PropertyListingCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

Select PropertyAddress, PropertyListingAddress, PropertyListingCity
from PortfolioProject.dbo.NashvilleHousing

--Using PARSENAME

Select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
, PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
, PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerResidenceAddress Nvarchar(255);

ALTER TABLE NashvilleHousing
Add OwnerResidenceCity Nvarchar(255);

ALTER TABLE NashvilleHousing
Add OwnerResidenceState Nvarchar(255);

Update NashvilleHousing
SET OwnerResidenceAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

Update NashvilleHousing
SET OwnerResidenceCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

Update NashvilleHousing
SET OwnerResidenceState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

Select OwnerAddress, OwnerResidenceAddress, OwnerResidenceCity, OwnerResidenceState
from PortfolioProject.dbo.NashvilleHousing

----------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in 'SoldAsvacant' Column 

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   End
from PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   End

----------------------------------------------------------------------------------------------------------------------------------------

-- Removing Duplicates (with CTE)

With RownNumCTE AS
(
Select *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 Order By UniqueID
			 ) row_num

from PortfolioProject.dbo.NashvilleHousing
)
Select *
from RownNumCTE
where row_num > 1

----------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused Data Columns(Not recommended for live projects, leave the columns as it is. Instead create a new Table and delete unused data columns)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate