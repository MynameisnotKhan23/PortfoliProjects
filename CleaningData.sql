--Standardize Date Format
Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add SalesDateConverted Date;

Update NashvilleHousing
SET SalesDateConverted = CONVERT(Date,SaleDate)


--Populate Property Adress Data 

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
Order By ParcelID




Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing A
Join PortfolioProject.dbo.NashvilleHousing B
    On A.ParcelID = B.ParcelID
	And a.[UniqueID ] <> B.[UniqueID ]
Where A.PropertyAddress is null


Update A
Set PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing A
Join PortfolioProject.dbo.NashvilleHousing B
    On A.ParcelID = B.ParcelID
	And a.[UniqueID ] <> B.[UniqueID ]


--Breaking out Adress into Individual Columns (Adress, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--Order By ParcelID


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Adress
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Adress 

From PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress NVARCHAR(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
Add PropertySplitCity NVARCHAR(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


Select *
From PortfolioProject..NashvilleHousing







Select OwnerAddress
From PortfolioProject..NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject..NashvilleHousing






ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity NVARCHAR(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState NVARCHAR(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject..NashvilleHousing



--Change Y and N to Yes and No in 'Sold as Vacant' field

Select Distinct(SoldAsVacant), COUNT(SoldasVacant)
From PortfolioProject..NashvilleHousing
Group By SoldAsVacant
Order By 2








Select SoldAsVacant
,Case When SoldasVacant = 'Y' THEN 'Yes'
      When SoldasVacant = 'N' THEN 'No'
	  ELSE SoldasVacant
	  End
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case When SoldasVacant = 'Y' THEN 'Yes'
      When SoldasVacant = 'N' THEN 'No'
	  ELSE SoldasVacant
	  End

-- Remove Duplicates

WITH RowNumCTE as ( 
Select *, 
   ROW_NUMBER() OVER(
   PARTITION BY ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				UniqueID
				)row_num

From PortfolioProject..NashvilleHousing
--Order By ParcelID
)
Select *
From RowNumCTE
Where row_num > 1 
Order By PropertyAddress



--Deleting Unused Colums


Select *
From PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate













