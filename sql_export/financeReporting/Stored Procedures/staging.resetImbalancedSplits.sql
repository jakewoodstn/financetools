-- Exported: 2026-06-21T21:55:42.316658+00:00
-- Schema:   staging
-- Object:   resetImbalancedSplits
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2021-02-07 22:10:31.900000
-- Modified: 2021-02-07 22:16:30.233000



CREATE PROC staging.resetImbalancedSplits (@startdate DATE, @enddate DATE)
AS
  BEGIN

    UPDATE bt  SET categoryStatus = 0 FROM finances.dbo.bankTransaction bt INNER JOIN staging.vwImbalancedSplits vis ON bt.transactionId = vis.transactionId 
    WHERE vis.accountingDate BETWEEN @startdate AND @enddate
  END
