-- Exported: 2026-06-21T21:55:41.468860+00:00
-- Schema:   utilities
-- Object:   simpleBudgetPrimeAllExpectedForYear
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2019-07-11 14:43:19.980000
-- Modified: 2020-06-23 04:14:25.683000

CREATE PROCEDURE utilities.simpleBudgetPrimeAllExpectedForYear (@year VARCHAR(4) = 2019)
AS
BEGIN

  IF OBJECT_ID('tempdb..#process') IS NOT NULL
    DROP TABLE #process
  SELECT
    be.*
   ,mdate
   ,used = 0 INTO #process
  FROM simpleBudgetExpected be
  INNER JOIN (SELECT
      simpleBudgetId
     ,MAX(be.transactionStartDate) mdate
    FROM simpleBudgetExpected be
    GROUP BY be.simpleBudgetId
    HAVING MAX(be.transactionStartDate) < '12/1/' + @year) maxBe
    ON be.simpleBudgetId = maxBe.simpleBudgetId
      AND be.transactionStartDate = maxBe.mdate

  SELECT
    *
  FROM #process

  WHILE EXISTS (SELECT TOP 1
      *
    FROM #process
    WHERE used = 0)
  BEGIN

  DECLARE @myKeyVal INT
  DECLARE @myVal SMALLMONEY
  DECLARE @mydate DATE
  DECLARE @myBudget INT

  SELECT TOP 1
    @myKeyVal = p.simpleBudgetExpectedId
   ,@mydate = DATEADD(DAY, 1, p.transactionEndDate)
   ,@myval =
    CASE
      WHEN mdate = '12/1/2018' THEN amount
      ELSE 0
    END
   ,@myBudget = simpleBudgetId
  FROM #process p
  WHERE used = 0

  DECLARE @paramDate VARCHAR(20) = '12/31/' + @year

  EXEC utilities.simpleBudgetPrimeExpected @simpleBudgetId = @myBudget
                                ,@startDate = @mydate
                                ,@enddate = @paramDate
                                ,@defaultAmount = @myval

  UPDATE #process
  SET USEd = 1
  WHERE simpleBudgetExpectedId = @myKeyVal

  END


  SELECT
    p.simpleBudgetId
   ,YEAR(be.transactionStartDate)
   ,COUNT(*)
  FROM simpleBudgetExpected be
  INNER JOIN #process p
    ON be.simpleBudgetId = p.simpleBudgetId
  WHERE be.transactionStartDate > p.mdate
  GROUP BY YEAR(be.transactionStartDate)
          ,p.simpleBudgetId
END
