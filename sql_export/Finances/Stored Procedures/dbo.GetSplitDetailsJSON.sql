-- Exported: 2026-06-21T21:55:41.302943+00:00
-- Schema:   dbo
-- Object:   GetSplitDetailsJSON
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2012-12-26 03:53:21.410000
-- Modified: 2020-06-23 03:39:47.950000

CREATE procedure dbo.GetSplitDetailsJSON(@transactionId bigint)
as 
begin

if object_id ('tempdb..#splitDetail') is not null drop table #splitDetail

create table #splitDetail
	(transactionid bigint,
	splittransactionid int,
	transactionDate date,
	description varchar(1000),
	categoryId int,
	categoryName varchar(255),
	amount money,
	bankorigDescription varchar(1000),
  tags VARCHAR(1000))

insert into #splitDetail
exec getsplitdetails @transactionid

--select * from #splitDetail

declare @f fieldList;
insert into @f(fieldName) 
values ('jsonkey2'),
('transactionId'),
('splittransactionid'),
('transactionDate'),
('description'),
('categoryid'),
('categoryname'),
('amount'),
('bankorigdescription'),
('tags')

exec json '(select cast(transactionid as varchar(20)) + ''|'' + cast(splitTransactionId as varchar(10)) as jsonkey2,* from #splitDetail) jsonsq','jsonkey2',@f

end
