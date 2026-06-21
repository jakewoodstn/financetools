-- Exported: 2026-06-21T21:55:41.450202+00:00
-- Schema:   utilities
-- Object:   DailyBalance_Process
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2011-12-05 23:43:13.933000
-- Modified: 2020-06-21 22:39:31.490000

CREATE PROCEDURE [dbo].[DailyBalance_Process](@accountId int, @measurementDate date, @computeFrom date=null, @direction int=1)
/***********************************************

IF OBJECT_ID('DailyBalance_Process','P') IS NOT NULL DROP PROCEDURE DailyBalance_Process
------
EXEC DailyBalance_Process;
***********************************************/

AS
BEGIN
	select @computeFrom = coalesce(@computeFrom, dateadd(d,-1*sign(@direction),@measurementdate));
	--DEBUG LINE
	--declare @account varchar(200) = '';declare @measurementDate date = '2011-12-01'; declare @computeFrom date = '2011-12-02';
	
	--declare @account varchar(200);
	declare @standingAmount money;
	declare @transactionAmount money;

	if @computeFrom = @measurementDate 
	BEGIN
		RETURN;
	END;
	
	IF @computeFrom > @measurementDate
	BEGIN
		select @transactionAmount = (-1 * coalesce(SUM(amount),0)) from bankTransaction 
		where 
			accountid = @accountId
			and transactionDate > @measurementDate
			and transactionDate <= @computeFrom;
	END;
	
	IF @computeFrom < @measurementDate
	BEGIN
	select @transactionAmount = coalesce(SUM(amount),0) from bankTransaction 
		where 
			accountid= @accountid
			and transactionDate <= @measurementDate
			and transactionDate > @computeFrom;
	END;
	
	--select @transactionAmount;
	
	SELECT @standingAmount = Amount from dbo.dailyBalance 
		where accountId=@accountId and MeasurementDate = @computeFrom;
    
    --select @standingAmount;
	delete DailyBalance where accountId=@accountId and MeasurementDate = @measurementDate
		
	insert into DailyBalance(accountId,Amount,MeasurementDate) 
		values (@accountId, @standingAmount + @transactionAmount, @measurementDate);

END;
