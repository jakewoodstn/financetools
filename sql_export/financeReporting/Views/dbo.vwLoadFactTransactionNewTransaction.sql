-- Exported: 2026-06-21T21:55:42.296897+00:00
-- Schema:   dbo
-- Object:   vwLoadFactTransactionNewTransaction
-- Type:     VIEW
-- Created:  2019-05-06 21:13:38.380000
-- Modified: 2020-06-28 13:53:06.540000

CREATE VIEW dbo.vwLoadFactTransactionNewTransaction
AS
SELECT
  t.remoteTransactionId
 ,t.remoteTransactionSplitId
 ,t.description
 ,t.payeeId
 ,t.categoryId
 ,t.categoryName
 ,t.subcategoryId
 ,t.accountId
 ,t.subbudgetId
 ,t.accountingDate
 ,t.dateSK
 ,t.expenseTierId
 ,t.amount
FROM staging.factTransaction t
LEFT JOIN dbo.factTransaction tProd
  ON t.remoteTransactionId = tProd.remoteTransactionId
    AND COALESCE(t.remoteTransactionSplitId, 0) = COALESCE(tprod.remoteTransactionSplitId, 0)
WHERE tprod.transactionId IS NULL
