-- Exported: 2026-06-21T21:55:41.282976+00:00
-- Schema:   dbo
-- Object:   assignCat
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2012-11-22 00:31:26.903000
-- Modified: 2020-06-23 03:49:28.040000

CREATE procedure assignCat(@transarray varchar(max),@catName varchar(1000)) as
begin

declare @Split varchar(1)=',';
declare @X xml;
declare @catId int;

select @catId 

select @catId=categoryid from vSpendingCategories where categoryName=@catName;

SELECT @X = CONVERT(xml,'<root><s>' + REPLACE(@transarray,@Split,'</s><s>') + '</s></root>')

create table #trans(transactionId bigint);

insert into #trans
SELECT [Value] = T.c.value('.','varchar(20)')
FROM @X.nodes('/root/s') T(c)

update bankTransaction set categoryId = @catId 
from bankTransaction inner join #trans on bankTransaction.transactionId=#trans.transactionId;

end;
