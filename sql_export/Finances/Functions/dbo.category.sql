-- Exported: 2026-06-21T21:55:41.280524+00:00
-- Schema:   dbo
-- Object:   category
-- Type:     SQL_SCALAR_FUNCTION
-- Created:  2012-03-25 12:09:33.483000
-- Modified: 2012-03-25 12:11:28.900000

CREATE function category(@catId int) returns varchar(255)
as 
begin 
	declare @res varchar(255);
	select top 1 @res=case when charindex(categoryName,'-',1) <> 0 then SUBSTRING(categoryname,1,charindex(categoryName,'-',1)-2) else categoryName end from spendingCategories where categoryId=@catid; 
	return @res;
end;
