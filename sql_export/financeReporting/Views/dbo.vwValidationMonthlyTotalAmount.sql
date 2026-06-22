-- Exported: 2026-06-21T21:55:42.314606+00:00
-- Schema:   dbo
-- Object:   vwValidationMonthlyTotalAmount
-- Type:     VIEW
-- Created:  2020-01-26 21:57:46.010000
-- Modified: 2021-02-07 21:40:11.247000

CREATE VIEW dbo.vwValidationMonthlyTotalAmount
  as
SELECT
  baseSet.*
 ,COALESCE(checkSet.checkMetric,0)checkMetric
FROM (SELECT
    d.actdate
   ,SUM(amount) AS baseMetric
  FROM finances.dbo.bankTransaction t
  INNER JOIN dimdate d
    ON t.accountingDate = d.StandardDate
  INNER JOIN staging.validationDateRange dr ON d.FullDate BETWEEN dr.minDate AND dr.maxDate
  GROUP BY d.ActDate) baseSet
LEFT JOIN (SELECT
    d.ActDate
   ,SUM(amount) AS checkMetric
  FROM factTransaction t
  INNER JOIN dimDate d
    ON t.dateSK = d.DateSK
  INNER JOIN staging.validationDateRange dr ON d.FullDate BETWEEN dr.minDate AND dr.maxDate
  GROUP BY d.ActDate) checkSet
  ON baseSet.ActDate = checkSet.ActDate
WHERE baseSet.baseMetric<>COALESCE(checkSet.checkMetric,0)
