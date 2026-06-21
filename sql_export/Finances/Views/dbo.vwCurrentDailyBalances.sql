-- Exported: 2026-06-21T21:55:41.444273+00:00
-- Schema:   dbo
-- Object:   vwCurrentDailyBalances
-- Type:     VIEW
-- Created:  2022-04-14 15:32:31.883000
-- Modified: 2022-04-14 15:32:31.883000


CREATE VIEW vwCurrentDailyBalances AS
SELECT
  db.*
FROM DailyBalance db
INNER JOIN (SELECT
    accountId
   ,MAX(MeasurementDate) MeasurementDate
  FROM dailyBalance
  GROUP BY accountId) mx
  ON db.accountId = mx.accountId
    AND db.MeasurementDate = mx.MeasurementDate
