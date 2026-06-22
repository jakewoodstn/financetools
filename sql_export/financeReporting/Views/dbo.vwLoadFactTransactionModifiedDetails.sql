-- Exported: 2026-06-21T21:55:42.296369+00:00
-- Schema:   dbo
-- Object:   vwLoadFactTransactionModifiedDetails
-- Type:     VIEW
-- Created:  2019-05-06 21:13:38.890000
-- Modified: 2020-06-28 13:57:37.937000

CREATE VIEW dbo.vwLoadFactTransactionModifiedDetails
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
INNER JOIN dbo.factTransaction tProd
  ON t.remoteTransactionId = tProd.remoteTransactionId
    AND COALESCE(t.remoteTransactionSplitId, 0) = COALESCE(tprod.remoteTransactionSplitId, 0)
WHERE COALESCE(t.payeeId, 0) <> COALESCE(tprod.payeeId, 0)
OR COALESCE(t.subcategoryId, 0) <> COALESCE(tprod.subcategoryId, 0)
OR COALESCE(t.accountId, 0) <> COALESCE(tprod.accountId, 0)
OR COALESCE(t.subbudgetId, 0) <> COALESCE(tprod.subbudgetId, 0)
OR COALESCE(t.dateSK, 0) <> COALESCE(tprod.dateSK, 0)
OR COALESCE(t.amount, 0) <> COALESCE(tprod.amount, 0)
OR COALESCE(t.expenseTierId, 0) <> COALESCE(tprod.expenseTierID, 0)
