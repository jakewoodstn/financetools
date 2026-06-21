-- Exported: 2026-06-21T21:55:41.300785+00:00
-- Schema:   dbo
-- Object:   changeDescription
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2012-11-11 23:18:54.627000
-- Modified: 2020-06-23 04:05:02.243000

Create procedure changeDescription(@tranId bigint, @newDesc varchar(1000)) as begin 
	
	update bankTransaction set description=@newDesc where transactionId=@tranId;
	select retVal=@@ROWCOUNT;
	
end;
