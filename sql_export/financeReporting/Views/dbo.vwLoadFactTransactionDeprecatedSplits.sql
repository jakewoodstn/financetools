-- Exported: 2026-06-21T21:55:42.296067+00:00
-- Schema:   dbo
-- Object:   vwLoadFactTransactionDeprecatedSplits
-- Type:     VIEW
-- Created:  2019-05-06 21:17:20.513000
-- Modified: 2020-06-28 13:53:13.630000

CREATE VIEW dbo.vwLoadFactTransactionDeprecatedSplits
AS
SELECT
  tProd.transactionId
 ,tProd.remoteTransactionId
 ,tProd.remoteTransactionSplitId
 ,tProd.payeeId
 ,tProd.subcategoryId
 ,tProd.accountId
 ,tProd.subbudgetId
 ,tProd.expenseTierID
 ,tProd.dateSK
 ,tProd.amount
FROM dbo.factTransaction tProd
INNER JOIN dimDate d
  ON tProd.dateSK = d.DateSK
INNER JOIN (SELECT
    MIN(accountingDate) minDate
   ,MAX(accountingDate) maxDate
  FROM staging.factTransaction t) guardrails
  ON d.FullDate BETWEEN guardrails.minDate AND guardrails.maxDate
LEFT JOIN staging.factTransaction t
  ON tProd.remoteTransactionId = t.remoteTransactionId
    AND COALESCE(tProd.remoteTransactionSplitId, 0) = COALESCE(t.remoteTransactionSplitId, 0)
WHERE t.remoteTransactionId IS NULL
