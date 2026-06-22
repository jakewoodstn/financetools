-- Exported: 2026-06-21T21:55:42.313488+00:00
-- Schema:   dbo
-- Object:   vwValidationEvent
-- Type:     VIEW
-- Created:  2021-02-07 23:24:59.310000
-- Modified: 2021-02-07 23:25:48.950000

CREATE VIEW dbo.vwValidationEvent AS
SELECT
  LTRIM(RTRIM(COALESCE(base.taggedEventTag, dw.eventName))) eventName
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
      AND e.taggedEventTag <> 'Follow' 
      AND e.taggedEventTag NOT IN (SELECT expenseTierName FROM dimExpenseTier et)
  GROUP BY e.taggedEventTag
) base
FULL OUTER JOIN (SELECT
    e.eventName
  ,e.eventDomainId
   ,COUNT(t.transactionId) obsCount
   ,SUM(t.amount) obsAmount
  FROM factEventTransaction et
  INNER JOIN factTransaction t
    ON et.transactionId = t.transactionId
  INNER JOIN dimEvent e
    ON et.eventId = e.eventId
  INNER JOIN dimDate d ON t.dateSK = d.DateSK
  INNER JOIN staging.validationDateRange dr ON d.FullDate BETWEEN dr.minDate AND dr.maxDate
  GROUP BY e.eventName,e.eventDomainId) dw
  ON LTRIM(RTRIM(base.taggedEventTag)) = LTRIM(RTRIM(dw.eventName))
WHERE (COALESCE(base.obsAmount, -100000) <> COALESCE(dw.obsAmount, -100000)) 
      OR (COALESCE(base.obsCount, -100000) <> COALESCE(dw.obsCount, -100000))
