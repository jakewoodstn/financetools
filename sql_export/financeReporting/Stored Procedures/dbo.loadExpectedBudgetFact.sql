-- Exported: 2026-06-21T21:55:42.292703+00:00
-- Schema:   dbo
-- Object:   loadExpectedBudgetFact
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2020-06-27 22:07:32.270000
-- Modified: 2021-02-07 18:53:10.540000


CREATE PROCEDURE dbo.loadExpectedBudgetFact (@startdate date,@enddate date)
AS
BEGIN
            
      DROP TABLE IF EXISTS #t
      CREATE TABLE #t (subBudgetId INT, dateSK INT, monthly SMALLMONEY, qtrly SMALLMONEY, yearly SMALLMONEY)
      
      INSERT INTO #t (subBudgetId,dateSK,monthly) SELECT subbudgetid,dateSK,amount FROM staging.budgetExpected e INNER JOIN dimDate d ON e.transactionStartDate = d.StandardDate
      
      UPDATE t SET qtrly=obs
       FROM #t t INNER JOIN dimdate d ON t.dateSK = d.DateSK  INNER JOIN (
        SELECT e.subbudgetId, d.ActQtr,SUM(amount) obs FROM staging.budgetExpected e
            INNER JOIN dimDate d ON d.StandardDate = e.transactionStartDate
            GROUP BY e.subbudgetId, d.ActQtr
        )sq ON t.subBudgetId = sq.subbudgetId AND d.ActQtr = sq.ActQtr
         
      UPDATE t SET yearly=obs
       FROM #t t INNER JOIN dimdate d ON t.dateSK = d.DateSK  INNER JOIN (
        SELECT e.subbudgetId, d.CalendarYearNumber,SUM(amount) obs FROM staging.budgetExpected e
            INNER JOIN dimDate d ON d.StandardDate = e.transactionStartDate
            GROUP BY e.subbudgetId, d.CalendarYearNumber
        )sq ON t.subBudgetId = sq.subbudgetId AND d.CalendarYearNumber=sq.CalendarYearNumber
      
       
      DELETE bes FROM factBudgetExpectedSpending bes 
          INNER JOIN dimDate d ON bes.dateSKStart = d.DateSK AND CAST(d.StandardDate AS DATE) BETWEEN @startdate AND @enddate
          LEFT JOIN #t t ON bes.subbudgetId = t.subBudgetId AND d.DateSK = t.dateSK
          WHERE t.subBudgetId IS NULL;

      UPDATE factBudgetExpectedSpending SET amountMonth=monthly, amountQuarter= t.qtrly, amountYear=t.yearly
        FROM factBudgetExpectedSpending bes INNER JOIN #t t ON bes.subbudgetId = t.subBudgetId AND bes.dateSKStart = t.dateSK

      INSERT INTO factBudgetExpectedSpending (subbudgetId, dateSKStart, dateSKEnd, amountMonth, amountQuarter, amountYear)
      SELECT t.subBudgetId
            ,t.dateSK
            ,d2.DateSK
            ,t.monthly
            ,t.qtrly
            ,t.yearly
      FROM #t t
          INNER JOIN dimDate d1 ON t.dateSK = d1.DateSK INNER JOIN dimDate d2 ON d1.LastDayOfMonth = d2.StandardDate
          LEFT JOIN factBudgetExpectedSpending bes 
              INNER JOIN dimDate d ON bes.dateSKStart = d.DateSK AND CAST(d.StandardDate AS DATE) BETWEEN @startdate AND @enddate
          ON bes.subbudgetId = t.subBudgetId AND d.DateSK = t.dateSK
          WHERE bes.subBudgetId IS NULL;

END
