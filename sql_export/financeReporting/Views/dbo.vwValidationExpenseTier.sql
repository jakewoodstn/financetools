-- Exported: 2026-06-21T21:55:42.313797+00:00
-- Schema:   dbo
-- Object:   vwValidationExpenseTier
-- Type:     VIEW
-- Created:  2021-02-07 23:23:41.743000
-- Modified: 2021-02-07 23:23:52.847000

CREATE VIEW dbo.vwValidationExpenseTier AS
SELECT
  LTRIM(RTRIM(COALESCE(base.taggedEventTag, dw.expenseTierName))) eventName
 ,base.obsAmount baseMetricAmount
 ,dw.obsAmount warehouseMetricAmount
 ,base.obsCount baseMetricCount
 ,dw.obsCount warehouseMetricCount
FROM (SELECT
    e.taggedEventTag
   ,COUNT(t.transactionId) obsCount
   ,SUM(COALESCE(splitAmount,t.amount)) obsAmount
  FROM finances.dbo.transactionTaggedEvent te
  INNER JOIN finances.dbo.bankTransaction t
  LEFT JOIN finances.dbo.categorySplitDetails sd ON t.transactionId = sd.parentTransactionId
    ON te.transactionId = t.transactionId AND COALESCE(sd.splitTransactionId,0) = COALESCE(te.splitTransactionId,0)
  INNER JOIN finances.dbo.taggedEvent e ON te.taggedEventId = e.taggedEventId
  INNER JOIN staging.validationDateRange dr ON t.accountingDate BETWEEN dr.minDate AND dr.maxDate
  WHERE t.transactionId IN (SELECT t1.remoteTransactionId FROM factTransaction t1)
      AND e.taggedEventTag IN (SELECT expenseTierName FROM dimExpenseTier et)
  GROUP BY e.taggedEventTag
) base
FULL OUTER JOIN (SELECT
    e1.expenseTierName
   ,COUNT(t.transactionId) obsCount
   ,SUM(t.amount) obsAmount
  FROM  factTransaction t
  INNER JOIN dimExpenseTier e1
    ON t.expenseTierID = e1.expenseTierId
  INNER JOIN dimDate d ON t.dateSK = d.DateSK
  INNER JOIN staging.validationDateRange dr ON d.FullDate BETWEEN dr.minDate AND dr.maxDate
  GROUP BY e1.expenseTierName) dw
  ON LTRIM(RTRIM(base.taggedEventTag)) = LTRIM(RTRIM(dw.expenseTierName))
WHERE (COALESCE(base.obsAmount, -100000) <> COALESCE(dw.obsAmount, -100000)) OR (COALESCE(base.obsCount, -100000) <> COALESCE(dw.obsCount, -100000))
