-- Exported: 2026-06-21T21:55:41.469339+00:00
-- Schema:   utilities
-- Object:   simpleBudgetPrimeExpected
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2017-05-11 04:51:12.113000
-- Modified: 2020-06-23 04:15:15.373000

CREATE PROCEDURE utilities.simpleBudgetPrimeExpected (@simpleBudgetId INT, @startDate DATE = '1/1/2015', @enddate DATE = NULL, @defaultAmount SMALLMONEY = 0.00)
AS
BEGIN

  --default end date value
  IF @enddate IS NULL
    SET @enddate = CAST(DATEADD(YEAR, 5, DATEADD(DAY, DATEDIFF(DAY, GETDATE(), '1/1/2017') - 1, GETDATE())) AS DATE);  --5 years out (including current year);

  --any existing?  do nothing.
  IF EXISTS (SELECT
      *
    FROM simpleBudgetExpected be
    WHERE be.simpleBudgetId = @simpleBudgetId
    AND (@enddate <= be.transactionStartDate
    OR @startDate BETWEEN be.transactionStartDate and be.transactionEndDate))
  BEGIN
--
-- (SELECT
--      *
--    FROM simpleBudgetExpected be
--    WHERE be.simpleBudgetId = @simpleBudgetId
--    AND (@enddate <= be.transactionEndDate
--        OR @startDate BETWEEN be.transactionStartDate and be.transactionEndDate))
    PRINT ('No action to take')
    RETURN;

  END;

  --create monthly budgets

  INSERT INTO simpleBudgetExpected (simpleBudgetId, amount, transactionStartDate, transactionEndDate, effectiveDate, retiredDate)
    SELECT DISTINCT
      @simpleBudgetId,
      @defaultAmount,
      FirstDayOfMonth,
      dd.LastDayOfMonth,
      GETDATE(),
      '12/31/2199'
    FROM DimDate dd
    WHERE dd.FullDate BETWEEN @startDate AND @enddate;

  SELECT
    *
  FROM simpleBudgetExpected be
  WHERE be.simpleBudgetId = @simpleBudgetId;


END
