-- Exported: 2026-06-21T21:55:41.300430+00:00
-- Schema:   dbo
-- Object:   changeAcctingDate
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2012-11-23 23:39:28.323000
-- Modified: 2020-06-23 04:05:02.247000

Create procedure [dbo].[changeAcctingDate](@tranId bigint, @newDate varchar(1000)) as begin 
	
	if ISDATE(@newDate)=1
	begin
	update bankTransaction set accountingDate=@newDate where transactionId=@tranId;
	select retVal=@@ROWCOUNT;
	end;
end;
