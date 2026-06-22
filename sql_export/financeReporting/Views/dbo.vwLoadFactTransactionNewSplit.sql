-- Exported: 2026-06-21T21:55:42.296627+00:00
-- Schema:   dbo
-- Object:   vwLoadFactTransactionNewSplit
-- Type:     VIEW
-- Created:  2019-05-06 21:13:38.917000
-- Modified: 2020-06-28 13:53:32.547000

CREATE VIEW dbo.vwLoadFactTransactionNewSplit
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
INNER JOIN (SELECT DISTINCT
    remoteTransactionId
  FROM dbo.factTransaction tProd
  WHERE tProd.remoteTransactionSplitId IS NULL) noSplits
  ON noSplits.remoteTransactionId = t.remoteTransactionId
WHERE t.remoteTransactionSplitId IS NOT NULL
