-- Exported: 2026-06-21T21:55:42.314083+00:00
-- Schema:   dbo
-- Object:   vwValidationExtraFactTransaction
-- Type:     VIEW
-- Created:  2020-01-27 01:01:02.973000
-- Modified: 2021-02-07 21:37:55.023000

CREATE VIEW dbo.vwValidationExtraFactTransaction AS
SELECT
  t.*
FROM factTransaction t
INNER JOIN (SELECT
    t.remoteTransactionId
   ,COALESCE(t.remoteTransactionSplitId, 0) splitId
  FROM factTransaction t
  INNER JOIN dimDate d ON t.dateSK = d.DateSK
  INNER JOIN staging.validationDateRange dr ON d.FullDate BETWEEN dr.minDate AND dr.maxDate
  EXCEPT
  SELECT
    transactionid
   ,COALESCE(btc.splitTransactionId, 0) splitid
  FROM finances.dbo.BankTransactionCat btc
  INNER JOIN staging.validationDateRange dr ON  btc.accountingDate BETWEEN dr.minDate AND dr.maxDate
  ) Sq
  ON Sq.remoteTransactionId = t.remotetransactionId
