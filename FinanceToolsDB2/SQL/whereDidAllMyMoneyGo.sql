DECLARE @type VARCHAR(20) = 'burndown';

DECLARE @sort TABLE (mode VARCHAR(255), subset INT, sort INT)
  INSERT into @sort VALUES
    ('cashflow',1,1),
    ('cashflow',2,1),
    ('cashflow',3,1),
    ('cashflow',4,1),
    ('burndown',1,3),
    ('burndown',2,3),
    ('burndown',3,1),
    ('burndown',4,2)


DECLARE @interim TABLE (
  interimId INT IDENTITY (1, 1) PRIMARY KEY,
  subset INT,
  weekOfYearNumber INT,
  budget VARCHAR(255),
  subBudget VARCHAR(255),
  description VARCHAR(1000),
  amount MONEY
);

DECLARE @core TABLE (
  income_expense_category VARCHAR(255),
  budget VARCHAR(255),
  subBudget VARCHAR(255),
  description VARCHAR(1000),
  accountingDate DATE,
  weekOfYearNumber INT,
  amount MONEY,
  simpleBudgetId INT,
  income_expense_actual VARCHAR(255),
  sortorder INT
);

INSERT INTO @core
  SELECT
    b.label1 AS income_expense_category,
    b.label2 AS budget,
    b.label3 AS subBudget,
    btc.description,
    btc.accountingDate,
    dd.weekOfYearNumber,
    btc.amount,
    b.simpleBudgetId,
    CASE WHEN btc.amount > 0 THEN 'income' ELSE 'expenses' END AS income_expense_actual,
    b.sortorder
  FROM simpleBudgetCalculatedActual bca
  INNER JOIN simpleBudgetExpected be
    ON bca.simpleBudgetExpectedId = be.simpleBudgetExpectedId
  INNER JOIN simpleBudget b
    ON be.simpleBudgetId = b.simpleBudgetId
  INNER JOIN simpleBudgetMaterializedTransactions bmt
    ON bca.simpleBudgetActualId = bmt.simpleBudgetActualId
  INNER JOIN BankTransactionCat btc
    ON bmt.transactionId = btc.transactionId
    AND COALESCE(bmt.splitTransactionId, 0) = COALESCE(btc.splitTransactionId, 0)
  INNER JOIN DimDate dd
    ON btc.accountingDate = dd.StandardDate
  WHERE transactionDate BETWEEN '3/1/2018' AND '3/31/2018';
-- categorized expenses
INSERT INTO @interim (subset, weekOfYearNumber, budget, subBudget, description, amount)
  SELECT
    1,
    weekOfYearNumber,

    budget,
    subBudget,
    NULL,
    SUM(core.amount)
  FROM @core core
  LEFT JOIN whereDidMyMoneyGoBreakoutControl dmmgbc
    ON core.simpleBudgetId = dmmgbc.simpleBudgetId
    AND YEAR(accountingDate) = dmmgbc.year
    AND weekOfYearNumber BETWEEN dmmgbc.weekNumberStarting AND dmmgbc.weekNumberEnding
    AND dmmgbc.breakoutIntoTransactions = 1
  WHERE dmmgbc.whereDidMyMoneyGoBreakoutControlId IS NULL
  AND core.income_expense_actual = 'expenses'
  GROUP BY weekOfYearNumber,
           budget,
           subBudget,
           sortorder,
           core.income_expense_category,
           income_expense_actual
  ORDER BY core.weekOfYearNumber, core.sortorder, core.budget, core.subBudget;
--individual expenses
INSERT INTO @interim (subset, weekOfYearNumber, budget, subBudget, description, amount)
  SELECT
    2,weekOfYearNumber,
    NULL,
    NULL,
    description,
    SUM(core.amount) AS amount
  FROM @core core
  INNER JOIN whereDidMyMoneyGoBreakoutControl dmmgbc
    ON core.simpleBudgetId = dmmgbc.simpleBudgetId
    AND YEAR(accountingDate) = dmmgbc.year
    AND weekOfYearNumber BETWEEN dmmgbc.weekNumberStarting AND dmmgbc.weekNumberEnding
    AND dmmgbc.breakoutIntoTransactions = 1
  WHERE core.income_expense_actual = 'expenses'
  GROUP BY weekOfYearNumber,
           description,
           sortorder,
           income_expense_actual
  ORDER BY weekOfYearNumber, sortorder, description;
--categorized income
INSERT INTO @interim (subset,weekOfYearNumber, budget, subBudget, description, amount)
  SELECT
    3, CASE when @type = 'burndown' THEN NULL else weekOfYearNumber END weekOfYearNumber,
    budget,
    subBudget,
    NULL,
    SUM(core.amount)
  FROM @core core
  LEFT JOIN whereDidMyMoneyGoBreakoutControl dmmgbc
    ON core.simpleBudgetId = dmmgbc.simpleBudgetId
    AND YEAR(accountingDate) = dmmgbc.year
    AND weekOfYearNumber BETWEEN dmmgbc.weekNumberStarting AND dmmgbc.weekNumberEnding
    AND dmmgbc.breakoutIntoTransactions = 1
  WHERE core.income_expense_actual = 'income'
  AND dmmgbc.whereDidMyMoneyGoBreakoutControlId IS NULL
  GROUP BY CASE when @type = 'burndown' THEN NULL else weekOfYearNumber END ,
           budget,
           subBudget,
           sortorder,
           core.income_expense_category,
           income_expense_actual
  ORDER BY CASE when @type = 'burndown' THEN NULL else weekOfYearNumber END , core.sortorder, core.budget, core.subBudget;
--individual income
INSERT INTO @interim (subset, weekOfYearNumber, budget, subBudget, description, amount)
  SELECT
    4,CASE when @type = 'burndown' THEN NULL else weekOfYearNumber END weekOfYearNumber,
    NULL,
    NULL,
    description,
    SUM(core.amount) AS amount
  FROM @core core
  INNER JOIN whereDidMyMoneyGoBreakoutControl dmmgbc
    ON core.simpleBudgetId = dmmgbc.simpleBudgetId
    AND YEAR(accountingDate) = dmmgbc.year
    AND weekOfYearNumber BETWEEN dmmgbc.weekNumberStarting AND dmmgbc.weekNumberEnding
    AND dmmgbc.breakoutIntoTransactions = 1
  WHERE core.income_expense_actual = 'income'
  GROUP BY CASE when @type = 'burndown' THEN NULL else weekOfYearNumber END ,
           description,
           sortorder,
           income_expense_actual
  ORDER BY weekOfYearNumber, sortorder, description;

SELECT
  s.mode, i.interimId,
          i.weekOfYearNumber,
          i.budget,
          i.subBudget,
          i.description,
          i.amount
FROM @interim i
  INNER JOIN @sort s on i.subset = s.subset
  WHERE s.mode=@type
ORDER BY mode,sort, weekOfYearNumber, interimId