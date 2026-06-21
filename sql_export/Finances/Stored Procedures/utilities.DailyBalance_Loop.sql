-- Exported: 2026-06-21T21:55:41.449339+00:00
-- Schema:   utilities
-- Object:   DailyBalance_Loop
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2011-12-18 07:09:36.023000
-- Modified: 2023-09-02 19:54:20.860000

CREATE procedure [utilities].[DailyBalance_Loop] (@accountId int, @minDate date=null, @maxDate date=null, @direction int=1)
AS
BEGIN
	
	set nocount on ;
	
	declare @minTranDate date;
	declare @maxTranDate date;
	declare @BalStartDate date;
	declare @dateCounter date;

	
	if @direction >0 
	begin
		select @maxTrandate =COALESCE(@maxDate,MAX(transactionDate)) from bankTransaction;
		set @minTranDate = COALESCE(@minDate, @maxTrandate);
		select @BalStartDate = MAX(MeasurementDate) from DailyBalance where MeasurementDate <= @minTranDate;
		set @dateCounter = DATEADD(d,@direction,@BalStartDate)
				
		WHILE @dateCounter <=@maxTranDate
		BEGIN
			--select @dateCounter
			exec utilities.DailyBalance_Process @accountId,@dateCounter,null,@direction;
			set @dateCounter = DATEADD(d,@direction,@dateCounter)
		END;
	END;
	ELSE
	BEGIN
		select @minTrandate =COALESCE(@minDate,MIN(transactionDate)) from bankTransaction;
		--select @minTranDate
		set @maxTranDate = COALESCE(@maxDate, @minTrandate);
		--select @maxTranDate
		select @BalStartDate = MIN(MeasurementDate) from DailyBalance where MeasurementDate > @maxTranDate;
		--select @BalStartDate
		set @dateCounter = DATEADD(d,@direction,@BalStartDate)
	
		WHILE @dateCounter >=@minTranDate
		BEGIN
			--select @dateCounter
			exec utilities.DailyBalance_Process @accountId,@dateCounter,null,@direction;
			set @dateCounter = DATEADD(d,@direction,@dateCounter)
		END;
		
	END;
	
END;
