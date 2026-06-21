-- Exported: 2026-06-21T21:55:41.302008+00:00
-- Schema:   dbo
-- Object:   deleteAllSplits
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2017-05-08 17:53:48.233000
-- Modified: 2020-06-23 04:05:02.243000


CREATE PROC deleteAllSplits(@transactionId bigint)
AS 
  BEGIN
    DELETE csd FROM categorySplitDetails csd WHERE csd.parentTransactionId = @transactionId;
    UPDATE bankTransaction set categoryStatus = 0, categoryId = NULL, category = 'Uncategorized' WHERE transactionId = @transactionId;
  END
