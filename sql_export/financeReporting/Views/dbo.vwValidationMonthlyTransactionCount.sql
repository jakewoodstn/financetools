-- Exported: 2026-06-21T21:55:42.315020+00:00
-- Schema:   dbo
-- Object:   vwValidationMonthlyTransactionCount
-- Type:     VIEW
-- Created:  2020-06-14 20:41:31.897000
-- Modified: 2021-02-07 21:40:32.397000

CREATE VIEW dbo.vwValidationMonthlyTransactionCount
  as
SELECT
  baseSet.*
 ,COALESCE(checkSet.checkMetric,0)checkMetric
FROM (SELECT
    d.actdate
   ,COUNT(transactionId) AS baseMetric
  FROM finances.dbo.bankTransaction t 
     LEFT JOIN finances.dbo.categorySplitDetails sd ON t.transactionId = sd.parentTransactionId
  INNER JOIN dimdate d
    ON t.accountingDate = d.StandardDate
  INNER JOIN staging.validationDateRange dr ON d.FullDate BETWEEN dr.minDate AND dr.maxDate
  GROUP BY d.ActDate) baseSet
LEFT JOIN (SELECT
    d.ActDate
   ,COUNT(t.remoteTransactionId) checkMetric
  FROM factTransaction t
  INNER JOIN dimDate d
    ON t.dateSK = d.DateSK
  INNER JOIN staging.validationDateRange dr ON d.FullDate BETWEEN dr.minDate AND dr.maxDate
  GROUP BY d.ActDate) checkSet
  ON baseSet.ActDate = checkSet.ActDate
WHERE baseSet.baseMetric<>COALESCE(checkSet.checkMetric,0)
