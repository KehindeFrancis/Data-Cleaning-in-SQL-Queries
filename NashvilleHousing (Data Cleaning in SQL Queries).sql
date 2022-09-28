/*

Data Cleaning in SQL Queries

*/

-------------------------------------------------------------------------------------------------------------------------------------------------------------



----- Sale Date Format

Select SaleDate
From [Project Portfolio 3]..NashvilleHousing

Select SaleDateConverted, CONVERT(Date,SaleDate) SD2
From [Project Portfolio 3]..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT (Date,SaleDate)


---- Alternatively

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT (Date,SaleDate)



-------------------------------------------------------------------------------------------------------------------------------------------------------------

----- Populate Proerty Address


Select *
From [Project Portfolio 3]..NashvilleHousing
Where PropertyAddress is null
Order By ParcelID


Select  a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
From [Project Portfolio 3]..NashvilleHousing AS a
    JOIN [Project Portfolio 3]..NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null

UPDATE a
SET PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
From [Project Portfolio 3]..NashvilleHousing AS a
    JOIN [Project Portfolio 3]..NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null




-------------------------------------------------------------------------------------------------------------------------------------------------------------


----- Breaking out Address into Individual Columns (Address, City, State)


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1) As Address
, SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress)) As Address
From [Project Portfolio 3]..NashvilleHousing



ALTER TABLE NashvilleHousing
Add PropertySplitAddress NVARCHAR(255); 


UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
Add PropertSplitCity NVARCHAR(255);


UPDATE NashvilleHousing
SET PropertSplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress))




----- OR, For OwnerAddress we can do 

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) OwnerSplitAddress,
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2) OwnerSplitCity,
PARSENAME(REPLACE(OwnerAddress, ',','.'),1) OwnerSplitState
From [Project Portfolio 3]..NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255); 


UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) 



ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)




-------------------------------------------------------------------------------------------------------------------------------------------------------------



------ Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Project Portfolio 3]..NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
   End
FROM [Project Portfolio 3]..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 ELSE SoldAsVacant
   End




-------------------------------------------------------------------------------------------------------------------------------------------------------------

----- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From [Project Portfolio 3]..NashvilleHousing
)
DELETE
From RowNumCTE
Where row_num > 1





-------------------------------------------------------------------------------------------------------------------------------------------------------------


----- Delete Unused Columns

Select *
From [Project Portfolio 3]..NashvilleHousing

ALTER TABLE [Project Portfolio 3]..NashvilleHousing
DROP Column PropertyAddress, SaleDate, OwnerAddress,TaxDistrict

















