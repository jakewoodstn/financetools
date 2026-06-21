-- Exported: 2026-06-21T21:55:41.422706+00:00
-- Schema:   dbo
-- Object:   topCat
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2020-06-23 03:08:41.363000
-- Modified: 2020-06-23 03:08:41.363000


CREATE procedure dbo.topCat(@account int, @numberReturn int, @durationDays int, @method varchar(20)='incidence')
as

begin

create table #t(categoryName varchar(255),rn int);

DECLARE @enddate DATETIME2;

SELECT @enddate = max(accountingDate) FROM bankTransaction t 

if @method='incidence' 
begin 
	if @account>0 
	insert into #t 
	select categoryName , rn from (
	select  
	 categoryName,ROW_NUMBER() over (order by count(*) desc) as rn 
	 FROM BankTransactionCat 
	 where accountId=@account 
		and accountingDate>=cast(DATEADD(D,-1*@durationDays,@enddate) as DATE) 
		and categoryStatus=-1 
	group by categoryName 
	 )sq where rn<=@numberReturn order by rn;
	 else
	insert into #t 
	select categoryName , rn from (
	select  
	 categoryName,ROW_NUMBER() over (order by count(*) desc) as rn 
	 FROM BankTransactionCat 
	 where accountingDate>=cast(DATEADD(D,-1*@durationDays,@enddate) as DATE) 
		and categoryStatus=-1 
	group by categoryName
	 )sq where rn<=@numberReturn order by categoryName;
	  
end
else if @method='expenditure'
begin 
	if @account>0 
	insert into #t 
	select categoryName , rn from (
	select  
	 categoryName,ROW_NUMBER() over (order by sum(abs(amount)) desc) as rn 
	 FROM BankTransactionCat 
	 where accountId=@account 
		and accountingDate>=cast(DATEADD(D,-1*@durationDays,@enddate) as DATE) 
		and categoryStatus=-1 
	group by categoryName 
	 )sq where rn<=@numberReturn order by categoryName;
	 else
	insert into #t 
	select categoryName , rn from (
	select  
	 categoryName,ROW_NUMBER() over (order by sum(abs(amount)) desc) as rn 
	 FROM BankTransactionCat 
	 where accountingDate>=cast(DATEADD(D,-1*@durationDays,@enddate) as DATE) 
		and categoryStatus=-1 
	group by categoryName 
	 )sq where rn<=@numberReturn order by categoryName;
	  
end
else if @method='proximity'

begin 
	if @account>0 
	insert into #t 
	select categoryName , rn from (
	select  
	 categoryName,ROW_NUMBER() over (order by max(accountingdate) desc) as rn 
	 FROM BankTransactionCat 
	 where accountId=@account 
		and accountingDate>=cast(DATEADD(D,-1*@durationDays,@enddate) as DATE) 
		and categoryStatus=-1 
	group by categoryName 
	 )sq where rn<=@numberReturn order by rn;
	 else
	insert into #t 
	select categoryName , rn from (
	select  
	 categoryName,ROW_NUMBER() over (order by max(accountingdate)  desc) as rn 
	 FROM BankTransactionCat 
	 where accountingDate>=cast(DATEADD(D,-1*@durationDays,@enddate) as DATE) 
		and categoryStatus=-1 
	group by categoryName 
	 )sq where rn<=@numberReturn order by categoryName;
	  
end
else 
begin
	insert into #t values (''); --nuttin, honey.
end;
select * from #t;
end
