-- Exported: 2026-06-21T21:55:42.314348+00:00
-- Schema:   dbo
-- Object:   vwValidationMissingBankTransaction
-- Type:     VIEW
-- Created:  2020-01-27 01:00:52.303000
-- Modified: 2021-02-07 21:39:16.270000

CREATE VIEW dbo.vwValidationMissingBankTransaction AS
  SELECT
  t.*
FROM finances.dbo.BankTransactionCat t
INNER JOIN (SELECT
    transactionid
   ,COALESCE(btc.splitTransactionId, 0) splitid
  FROM finances.dbo.BankTransactionCat btc 
  INNER JOIN staging.validationDateRange dr ON  btc.accountingDate BETWEEN mindate  AND dr.maxDate
  EXCEPT
  SELECT
    t.remoteTransactionId
   ,COALESCE(t.remoteTransactionSplitId, 0)
  FROM factTransaction t
    INNER JOIN dimDate d ON t.dateSK = d.DateSK 
    INNER JOIN staging.validationDateRange dr ON d.FullDate BETWEEN dr.mindate AND dr.maxDate
    ) Sq
  ON Sq.transactionId = t.transactionId
