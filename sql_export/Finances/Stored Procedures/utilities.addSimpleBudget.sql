-- Exported: 2026-06-21T21:55:41.447638+00:00
-- Schema:   utilities
-- Object:   addSimpleBudget
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2018-04-08 19:20:34.247000
-- Modified: 2020-06-21 22:22:27.093000

CREATE PROCEDURE dbo.addSimpleBudget (@label1 VARCHAR(255), @label2 VARCHAR(255), @label3 VARCHAR(255), @defaultAmount SMALLMONEY = 0.00, @startDate DATE = '1/1/2015', @endDate DATE = NULL)
AS
BEGIN

  DECLARE @sortOrder INT;
  DECLARE @out TABLE (
    idValue INT
  );

  DECLARE @me VARCHAR(255) = OBJECT_NAME(@@procid) + ' - ' + SUSER_SNAME();

  IF EXISTS (SELECT
      *
    FROM simpleBudget b
    WHERE label1 = @label1
    AND b.label2 = @label2
    AND b.label3 = @label3)
    RETURN; --do nothing if duplicate entry

  IF EXISTS (SELECT
      *
    FROM simpleBudget b
    WHERE label1 = @label1
    AND b.label2 = @label2)
    SELECT
      @sortOrder = MAX(sortOrder)
    FROM simpleBudget b
    WHERE label1 = @label1
    AND b.label2 = @label2
  ELSE
    SELECT
      @sortOrder = MAX(sortOrder)
    FROM simpleBudget b
    WHERE label1 = @label1;

  UPDATE simpleBudget
  SET sortOrder = sortOrder + 1
  WHERE sortOrder > @sortOrder;

  INSERT INTO simpleBudget (label1, label2, label3, created_at, created_by, sortOrder)
  OUTPUT INSERTED.simpleBudgetId INTO @out (idValue)
    SELECT
      @label1,
      @label2,
      @label3,
      SYSDATETIME(),
      @me,
      @sortOrder + 1;

  DECLARE @sbid INT;
  SELECT
    @sbid = idValue
  FROM @out;

  EXEC simpleBudgetPrimeExpected @simpleBudgetId = @sbid,
                                 @startDate = @startDate,
                                 @endDate = @endDate,
                                 @defaultAmount = @defaultAmount;

  SELECT
    sbs.*
  FROM vwSimpleBudgetSummary sbs
  INNER JOIN @out o
    ON sbs.simpleBudgetId = o.idValue;

END
  ;
