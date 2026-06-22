-- Exported: 2026-06-21T21:55:42.312323+00:00
-- Schema:   dbo
-- Object:   vwPivotBasePayeeUsage
-- Type:     VIEW
-- Created:  2020-06-14 19:24:54.763000
-- Modified: 2020-06-14 19:24:54.763000


CREATE VIEW vwPivotBasePayeeUsage
AS
SELECT
  sq2.CalendarYearNumber
 ,sq2.payeeId
 ,sq2.alphaIndex
 ,ROW_NUMBER() OVER (PARTITION BY sq2.CalendarYearNumber, sq2.alphaIndex ORDER BY sq2.name) numericIndex
 ,sq2.name
 ,numTransaction
FROM (SELECT
    sq.CalendarYearNumber
   ,sq.payeeId
   ,CASE
      WHEN LEFT(p.payeeName, 1) LIKE '[0-9]' THEN '#'
      ELSE LEFT(p.payeeName, 1)
    END alphaIndex
   ,p.payeeName AS name
   ,sq.obs AS numTransaction

  FROM dimPayee p
  INNER JOIN (SELECT
      d.CalendarYearNumber
     ,payeeid
     ,COUNT(*) obs
    FROM factTransaction t
    INNER JOIN dimDate d
      ON t.dateSK = d.DateSK
    GROUP BY t.payeeId
            ,d.CalendarYearNumber) sq
    ON p.payeeId = sq.payeeId) sq2
