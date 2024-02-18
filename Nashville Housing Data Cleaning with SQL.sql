/*

Nashville Housing Data Cleaning using SQL Queries

*/

Select *
From PortfolioProject.dbo.NashvilleHousing


---------1-standardize date format-----------------------------------------------------------------------------

select SaleDate, convert(date, SaleDate) as SaleDateConverted
from PortfolioProject.dbo.NashvilleHousing;

alter table PortfolioProject.dbo.NashvilleHousing
add SaleDateConverted Date;

update PortfolioProject.dbo.NashvilleHousing
set SaleDateConverted = convert(date, SaleDate);



---------2-Populate Property Address data-----------------------------------------------------------------------------


select PropertyAddress 
from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null;

Select a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.[UniqueID ], b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing as a
join PortfolioProject.dbo.NashvilleHousing as b 
on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


---------3-Breaking out Address into Individual Columns (Address, City, State)---------------------------------------

select * 
from PortfolioProject.dbo.NashvilleHousing;


select PropertyAddress, 
substring(PropertyAddress, 1 , charindex(',', PropertyAddress)-1) as Address,
substring(PropertyAddress, charindex(',', PropertyAddress)+1, len(PropertyAddress)) as City
from PortfolioProject.dbo.NashvilleHousing;

alter table PortfolioProject.dbo.NashvilleHousing
add PropertySplitAddress Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress, 1 , charindex(',', PropertyAddress)-1);

alter table PortfolioProject.dbo.NashvilleHousing
add PropertySplitCity Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set PropertySplitCity = substring(PropertyAddress, charindex(',', PropertyAddress)+1, len(PropertyAddress)) 

-- using the parsename() and replace() funcfions to divide the owner address into address city and state

select * from PortfolioProject.dbo.NashvilleHousing;

select OwnerAddress,
parsename(replace(OwnerAddress, ',', '.'), 3) as address,
parsename(replace(OwnerAddress, ',', '.'), 2) as city,
parsename(replace(OwnerAddress, ',', '.'), 1) as state
from PortfolioProject.dbo.NashvilleHousing;

alter table PortfolioProject.dbo.NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.'), 3);

alter table PortfolioProject.dbo.NashvilleHousing
add OwnerSplitCity Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.'), 2);


alter table PortfolioProject.dbo.NashvilleHousing
add OwnerSplitState Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress, ',', '.'), 1);




---------4-Change Y and N to Yes and No in "Sold as Vacant" field---------------------------------------

select *
from PortfolioProject.dbo.NashvilleHousing;

select distinct(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing;

--- we going to use case statement to do this

select SoldAsVacant, 
	case 
	when SoldAsVacant = 'N' 
		then 'No' 
	when SoldAsVacant = 'Y' 
		then 'Yes' 
	else SoldAsVacant 
	end
from PortfolioProject.dbo.NashvilleHousing
where SoldAsVacant in ('N','Y');

update PortfolioProject.dbo.NashvilleHousing
set SoldAsVacant = case 
	when SoldAsVacant = 'N' 
		then 'No' 
	when SoldAsVacant = 'Y' 
		then 'Yes' 
	else SoldAsVacant 
	end;

select SoldAsVacant 
from PortfolioProject.dbo.NashvilleHousing
where SoldAsVacant in('N','Y');


---------5-Remove Duplicates-----------------------------------------------------------------------------

select * 
from  PortfolioProject.dbo.NashvilleHousing;

-- we are going to need to find rows with same data in all the columns expect for the uniqueId column

-- using row_number() window functions for it--


select *, 
	row_number() over (
	partition by ParcelID,
				LandUse, 
				PropertyAddress,
				SaleDate, SalePrice,
				LegalReference 
				order by 
				UniqueID ) as row_num
from PortfolioProject.dbo.NashvilleHousing;


with CTE_row_num as(
select *,
row_number() over (
	partition by ParcelID, 
				LandUse, 
				PropertyAddress,
				SaleDate, SalePrice, 
				LegalReference 
				order by 
				UniqueID ) as row_num
from PortfolioProject.dbo.NashvilleHousing

)
delete 
from CTE_row_num
where row_num > 1

with CTE_row_num as(
select *,
row_number() over (
		partition by ParcelID, 
					LandUse,
					PropertyAddress, 
					SaleDate, SalePrice, 
					LegalReference
					order by
					UniqueID ) as row_num
from PortfolioProject.dbo.NashvilleHousing

)
select * 
from CTE_row_num
where row_num > 1

---------6-Delete Unused Columns-----------------------------------------------------------------------------

select * from PortfolioProject.dbo.NashvilleHousing;

alter table PortfolioProject.dbo.NashvilleHousing
drop column PropertyAddress, SaleDate, OwnerAddress, TaxDistrict


----------------The End---------------------------------------------------------------------------------


