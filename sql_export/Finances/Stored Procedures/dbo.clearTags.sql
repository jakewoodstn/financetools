-- Exported: 2026-06-21T21:55:41.301720+00:00
-- Schema:   dbo
-- Object:   clearTags
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2016-03-06 14:40:21.203000
-- Modified: 2020-06-23 04:05:02.240000

CREATE PROCEDURE clearTags (@transactionId BIGINT)
  AS
  BEGIN
    
  DELETE from transactionTaggedEvent WHERE transactionId=@transactionId
    
  DELETE from taggedEvent WHERE taggedEventId NOT IN (SELECT taggedEventId FROM transactionTaggedEvent)  

  END
