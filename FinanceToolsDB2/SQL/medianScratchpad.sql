USE Finances
GO;

;

ALTER PROCEDURE dbo.captureExpenseMetrics (@incomeExpense VARCHAR(255), @budget VARCHAR(255), @subbudget VARCHAR(255), @timeframe VARCHAR(255), @timeValue VARCHAR(255))
AS
BEGIN

  DECLARE @metrics TABLE (
    income_expense VARCHAR(255),
    budget VARCHAR(255),
    subBudget VARCHAR(255),
    obs INT,
    nonzeroObs INT,
    totalExpense MONEY,
    minExpense MONEY,
    maxExpense MONEY,
    medianExpense MONEY,
    medianObservedExpense MONEY,
    meanExpense MONEY,
    stDevExpense MONEY
  )

  DECLARE @base TABLE (
    simpleBudgetId INT,
    income_expense VARCHAR(255),
    budget VARCHAR(255),
    subBudget VARCHAR(255),
    transactionId INT,
    accountingDate DATE,
    expenseAmount MONEY,
    incomeAmount MONEY
  )



  INSERT INTO @base
    SELECT
      b.simpleBudgetId,
      b.label1 Income_Expense,
      b.label2 budget,
      b.label3 subBudget,
      bmt.transactionId,
      t.accountingDate,
      CASE WHEN t.amount < 0 THEN t.amount ELSE 0 END expenseAmount,
      CASE WHEN t.amount < 0 THEN 0 ELSE t.amount END incomeAmount
    FROM simpleBudgetMaterializedTransactions bmt
    INNER JOIN simpleBudgetCalculatedActual bca
      ON bmt.simpleBudgetActualId = bca.simpleBudgetActualId
    INNER JOIN simpleBudgetExpected be
      ON bca.simpleBudgetExpectedId = be.simpleBudgetExpectedId
    INNER JOIN simpleBudget b
      ON be.simpleBudgetId = b.simpleBudgetId
    INNER JOIN bankTransaction t
      ON bmt.transactionId = t.transactionId
    INNER JOIN DimDate dd
      ON accountingDate = StandardDate
    WHERE b.label1 = @incomeExpense
    AND (b.label2 = @budget
    OR @budget = '')
    AND (b.label3 = @subbudget
    OR @subbudget = '')
    AND
      CASE WHEN @timeframe = 'Month' THEN actDate WHEN @timeframe = 'Quarter' THEN ActQtr WHEN
      @timeframe = 'Year' THEN CalendarYearNumber ELSE '' END
    = @timeValue;


  DECLARE @baseMonth TABLE (
    simpleBudgetId INT,
    income_expense VARCHAR(255),
    budget VARCHAR(255),
    subBudget VARCHAR(255),
    actDate VARCHAR(6),
    expenseAmount MONEY,
    incomeAmount MONEY
  )


  INSERT INTO @baseMonth (simpleBudgetId, income_expense, budget, subBudget, actDate, expenseAmount, incomeAmount)

    SELECT
      simpleBudgetId,
      income_expense,
      budget,
      subBudget,
      dbo.actDate(accountingDate),
      SUM(expenseAmount),
      SUM(incomeAmount)
    FROM @base
    GROUP BY simpleBudgetId,
             income_expense,
             budget,
             subBudget,
             dbo.actDate(accountingDate)

  INSERT INTO @baseMonth (simpleBudgetId, income_expense, budget, subBudget, actDate, expenseAmount, incomeAmount)
    SELECT
      sq.*,
      0,
      0
    FROM (SELECT DISTINCT
      simpleBudgetId,
      income_expense,
      budget,
      subBudget,
      dd.actDate
    FROM @baseMonth,
         DimDate dd
    WHERE CASE WHEN @timeframe = 'Month' THEN dd.actDate WHEN @timeframe = 'Quarter' THEN ActQtr WHEN
    @timeframe = 'Year' THEN CalendarYearNumber ELSE '' END
    = @timeValue
    AND dd.StandardDate <= GETDATE()
    EXCEPT
    SELECT
      simpleBudgetId,
      income_expense,
      budget,
      subBudget,
      actDate
    FROM @baseMonth) sq

  DECLARE @ct TABLE (
    income_expense VARCHAR(255),
    budget VARCHAR(255),
    subBudget VARCHAR(255),
    obs INT,
    allCt INT
  )


  INSERT INTO @metrics (income_expense, budget, subBudget, obs, nonzeroObs, totalExpense, minExpense, maxExpense)
    SELECT
      income_expense,
      budget,
      subBudget,
      COUNT(1),
      SUM(CASE WHEN ABS(expenseAmount) > 0 THEN 1 ELSE 0 END),
      SUM(expenseAmount),
      MAX(CASE WHEN expenseAmount = 0 THEN -9999999999999 ELSE expenseAmount END),
      MIN(expenseAmount)
    FROM @baseMonth
    GROUP BY income_expense,
             budget,
             subBudget;

  INSERT INTO @ct (income_expense, budget, subBudget, obs, allCt)
    SELECT
      income_expense,
      budget,
      subBudget,
      nonzeroObs,
      obs
    FROM @metrics;




  --observed values, odd # of observations
  WITH medbase
  AS (SELECT
    rn = ROW_NUMBER() OVER (PARTITION BY income_expense, budget, subBudget ORDER BY ABS(expenseAmount)),
    btc.income_expense,
    budget,
    subBudget,
    expenseAmount
  FROM (SELECT
    b.income_expense,
    b.budget,
    b.subBudget,
    SUM(expenseAmount) expenseAmount
  FROM @baseMonth b
  INNER JOIN @ct c
    ON b.income_expense = c.income_expense
    AND b.budget = c.budget
    AND b.subBudget = c.subBudget
  WHERE obs % 2 = 1
  GROUP BY actDate,
           b.income_expense,
           b.budget,
           b.subBudget
  HAVING ABS(SUM(expenseAmount)) > 0) btc)
  UPDATE m
  SET medianObservedExpense = s.medianObservedExpense
  FROM @metrics m
  INNER JOIN (SELECT
    medbase.income_expense,
    medbase.budget,
    medbase.subBudget,
    AVG(expenseAmount) medianObservedexpense
  FROM medbase
  INNER JOIN (SELECT

    medbase.income_expense,
    medbase.budget,
    medbase.subBudget,
    MIN(rn) minrn
  FROM medbase
  INNER JOIN (SELECT
    medbase.income_expense,
    medbase.budget,
    medbase.subBudget,
    MAX(rn) * 1.0 maxrn
  FROM medbase
  GROUP BY income_expense,
           budget,
           subBudget) maxsq
    ON medbase.income_expense = maxsq.income_expense
    AND medbase.budget = maxsq.budget
    AND medbase.subBudget = maxsq.subBudget
  WHERE rn * 1.0 / maxrn >= 0.5
  GROUP BY medbase.income_expense,
           medbase.budget,
           medbase.subBudget) mrn
    ON medbase.income_expense = mrn.income_expense
    AND medbase.budget = mrn.budget
    AND medbase.subBudget = mrn.subBudget
    AND medbase.rn = mrn.minrn
  GROUP BY medbase.income_expense,
           medbase.budget,
           medbase.subBudget) s
    ON m.income_expense = s.income_expense
    AND m.budget = s.budget
    AND m.subBudget = s.subBudget;

  --observed values, even # of observations
  WITH medbase
  AS (SELECT
    rn = ROW_NUMBER() OVER (PARTITION BY income_expense, budget, subBudget ORDER BY ABS(expenseAmount)),
    btc.income_expense,
    budget,
    subBudget,
    expenseAmount
  FROM (SELECT
    b.income_expense,
    b.budget,
    b.subBudget,
    SUM(expenseAmount) expenseAmount
  FROM @baseMonth b
  INNER JOIN @ct c
    ON b.income_expense = c.income_expense
    AND b.budget = c.budget
    AND b.subBudget = c.subBudget
  WHERE obs % 2 = 0
  GROUP BY actDate,
           b.income_expense,
           b.budget,
           b.subBudget
  HAVING ABS(SUM(expenseAmount)) > 0) btc)
  UPDATE m
  SET medianObservedExpense = s.medianObservedExpense
  FROM @metrics m
  INNER JOIN (SELECT
    medbase.income_expense,
    medbase.budget,
    medbase.subBudget,
    AVG(expenseAmount) medianObservedexpense
  FROM medbase
  INNER JOIN (SELECT

    medbase.income_expense,
    medbase.budget,
    medbase.subBudget,
    MIN(rn) minrn
  FROM medbase
  INNER JOIN (SELECT
    medbase.income_expense,
    medbase.budget,
    medbase.subBudget,
    MAX(rn) * 1.0 maxrn
  FROM medbase
  GROUP BY income_expense,
           budget,
           subBudget) maxsq
    ON medbase.income_expense = maxsq.income_expense
    AND medbase.budget = maxsq.budget
    AND medbase.subBudget = maxsq.subBudget
  WHERE rn * 1.0 / maxrn >= 0.5
  GROUP BY medbase.income_expense,
           medbase.budget,
           medbase.subBudget) mrn
    ON medbase.income_expense = mrn.income_expense
    AND medbase.budget = mrn.budget
    AND medbase.subBudget = mrn.subBudget
    AND medbase.rn IN (mrn.minrn, mrn.minrn + 1)
  GROUP BY medbase.income_expense,
           medbase.budget,
           medbase.subBudget) s
    ON m.income_expense = s.income_expense
    AND m.budget = s.budget
    AND m.subBudget = s.subBudget;


  --all values, odd # of observations
  WITH medbase
  AS (SELECT
    rn = ROW_NUMBER() OVER (PARTITION BY income_expense, budget, subBudget ORDER BY ABS(expenseAmount)),
    btc.income_expense,
    budget,
    subBudget,
    expenseAmount
  FROM (SELECT
    b.income_expense,
    b.budget,
    b.subBudget,
    SUM(expenseAmount) expenseAmount
  FROM @baseMonth b
  INNER JOIN @ct c
    ON b.income_expense = c.income_expense
    AND b.budget = c.budget
    AND b.subBudget = c.subBudget
  WHERE c.allCt % 2 = 1
  GROUP BY actDate,
           b.income_expense,
           b.budget,
           b.subBudget) btc)
  UPDATE m
  SET medianExpense = s.medianExpense
  FROM @metrics m
  INNER JOIN (SELECT
    medbase.income_expense,
    medbase.budget,
    medbase.subBudget,
    AVG(expenseAmount) medianexpense
  FROM medbase
  INNER JOIN (SELECT

    medbase.income_expense,
    medbase.budget,
    medbase.subBudget,
    MIN(rn) minrn
  FROM medbase
  INNER JOIN (SELECT
    medbase.income_expense,
    medbase.budget,
    medbase.subBudget,
    MAX(rn) * 1.0 maxrn
  FROM medbase
  GROUP BY income_expense,
           budget,
           subBudget) maxsq
    ON medbase.income_expense = maxsq.income_expense
    AND medbase.budget = maxsq.budget
    AND medbase.subBudget = maxsq.subBudget
  WHERE rn * 1.0 / maxrn >= 0.5
  GROUP BY medbase.income_expense,
           medbase.budget,
           medbase.subBudget) mrn
    ON medbase.income_expense = mrn.income_expense
    AND medbase.budget = mrn.budget
    AND medbase.subBudget = mrn.subBudget
    AND medbase.rn = mrn.minrn
  GROUP BY medbase.income_expense,
           medbase.budget,
           medbase.subBudget) s
    ON m.income_expense = s.income_expense
    AND m.budget = s.budget
    AND m.subBudget = s.subBudget;

  --all values, even # of observations
  WITH medbase
  AS (SELECT
    rn = ROW_NUMBER() OVER (PARTITION BY income_expense, budget, subBudget ORDER BY ABS(expenseAmount)),
    btc.income_expense,
    budget,
    subBudget,
    expenseAmount
  FROM (SELECT
    b.income_expense,
    b.budget,
    b.subBudget,
    SUM(expenseAmount) expenseAmount
  FROM @baseMonth b
  INNER JOIN @ct c
    ON b.income_expense = c.income_expense
    AND b.budget = c.budget
    AND b.subBudget = c.subBudget
  WHERE c.allCt % 2 = 0
  GROUP BY actDate,
           b.income_expense,
           b.budget,
           b.subBudget) btc)
  UPDATE m
  SET medianExpense = s.medianExpense
  FROM @metrics m
  INNER JOIN (SELECT
    medbase.income_expense,
    medbase.budget,
    medbase.subBudget,
    AVG(expenseAmount) medianexpense
  FROM medbase
  INNER JOIN (SELECT

    medbase.income_expense,
    medbase.budget,
    medbase.subBudget,
    MIN(rn) minrn
  FROM medbase
  INNER JOIN (SELECT
    medbase.income_expense,
    medbase.budget,
    medbase.subBudget,
    MAX(rn) * 1.0 maxrn
  FROM medbase
  GROUP BY income_expense,
           budget,
           subBudget) maxsq
    ON medbase.income_expense = maxsq.income_expense
    AND medbase.budget = maxsq.budget
    AND medbase.subBudget = maxsq.subBudget
  WHERE rn * 1.0 / maxrn >= 0.5
  GROUP BY medbase.income_expense,
           medbase.budget,
           medbase.subBudget) mrn
    ON medbase.income_expense = mrn.income_expense
    AND medbase.budget = mrn.budget
    AND medbase.subBudget = mrn.subBudget
    AND medbase.rn IN (mrn.minrn, mrn.minrn + 1)
  GROUP BY medbase.income_expense,
           medbase.budget,
           medbase.subBudget) s
    ON m.income_expense = s.income_expense
    AND m.budget = s.budget
    AND m.subBudget = s.subBudget;



  UPDATE @metrics
  SET medianObservedExpense = 0
  WHERE medianObservedExpense IS NULL;

  UPDATE m
  SET meanExpense = s.meanExpense,
      stDevExpense = s.stDevExpense
  FROM @metrics m
  INNER JOIN (SELECT
    income_expense,
    budget,
    subBudget,
    ROUND(AVG(expenseAmount), 2) meanExpense,
    ROUND(POWER(VAR(sq.expenseAmount), 0.5), 2) stDevExpense
  FROM (SELECT
    actDate,
    income_expense,
    budget,
    subBudget,
    expenseAmount
  FROM @baseMonth) sq
  GROUP BY sq.income_expense,
           sq.budget,
           sq.subBudget) s
    ON m.income_expense = s.income_expense
    AND m.budget = s.budget
    AND m.subBudget = s.subBudget


  SELECT
    *
  FROM @metrics;

END;

GO


