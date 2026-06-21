-- Exported: 2026-06-21T21:55:41.302304+00:00
-- Schema:   dbo
-- Object:   deleteSplit
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2012-12-31 23:07:30.053000
-- Modified: 2020-06-23 04:05:02.240000


create procedure deleteSplit(@splitId int = 0) as begin
delete categorySplitDetails where splitTransactionId=@splitId
end;
