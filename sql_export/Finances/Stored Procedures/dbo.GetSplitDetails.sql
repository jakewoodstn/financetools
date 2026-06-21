-- Exported: 2026-06-21T21:55:41.302616+00:00
-- Schema:   dbo
-- Object:   GetSplitDetails
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2012-01-08 22:10:14.417000
-- Modified: 2020-06-23 03:39:47.950000

CREATE procedure dbo.GetSplitDetails(@parentId bigint)
as
begin
	select 
		bt.transactionId
		,coalesce(csd.splitTransactionId,0) splitTransactionId
		, bt.transactionDate
		, bt.description
		, coalesce(csd.categoryId,bt.categoryId) categoryId
		, cat.categoryName
		, coalesce(csd.splitAmount, bt.amount) amount
		, bankOrigDescription
    , bt.tags 
	from 
		bankTransactionCat bt 
		left join categorySplitDetails csd on bt.splitTransactionId = csd.splitTransactionId
		left join vSpendingCategories cat on coalesce(csd.categoryId,bt.categoryId) = cat.categoryid	
		
	where bt.transactionId = @parentId
end;
