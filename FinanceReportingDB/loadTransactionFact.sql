USE financeReporting
GO

CREATE PROCEDURE loadTransactionFact (@startdate DATE = NULL, @enddate DATE = NULL)

AS
BEGIN

  IF @startdate IS NULL
    SELECT
      @startdate = DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) - 1, 0)
     ,@enddate = GETDATE()

  IF OBJECT_ID('staging.factTransaction') IS NOT NULL
  BEGIN
    TRUNCATE TABLE staging.factTransaction
  END
  ELSE
  BEGIN

    CREATE TABLE staging.factTransaction (

      remoteTransactionId INT
     ,remoteTransactionSplitId INT
     ,description VARCHAR(255)
     ,payeeId INT
     ,categoryId INT
     ,categoryName VARCHAR(255)
     ,subcategoryId INT
     ,accountId INT
     ,budgetLabel1 VARCHAR(255)
     ,budgetLabel2 VARCHAR(255)
     ,budgetLabel3 VARCHAR(255)
     ,subbudgetId INT
     ,accountingDate VARCHAR(10)
     ,dateSK INT
     ,amount SMALLMONEY

    )

  END


  INSERT INTO staging.factTransaction (remoteTransactionId, remoteTransactionSplitId, description, categoryId, accountId, budgetLabel1, budgetLabel2, budgetLabel3, accountingDate, amount)
    SELECT
      t.transactionId
     ,sd.splitTransactionId
     ,description
     ,CASE
        WHEN t.categoryStatus = 0 THEN 0
        ELSE COALESCE(sd.categoryId, t.categoryId)
      END
     ,t.accountId
     ,b.label1
     ,b.label2
     ,b.label3
     ,accountingDate
     ,COALESCE(sd.splitAmount, t.amount)
    FROM Finances.dbo.bankTransaction t
    LEFT JOIN Finances.dbo.categorySplitDetails sd
      ON t.transactionId = sd.parentTransactionId
    LEFT JOIN Finances.dbo.simpleBudgetMaterializedTransactions bmt
    INNER JOIN Finances.dbo.simpleBudgetCalculatedActual bca
      ON bmt.simpleBudgetActualId = bca.simpleBudgetActualId
    INNER JOIN Finances.dbo.simpleBudgetExpected be
      ON bca.simpleBudgetExpectedId = be.simpleBudgetExpectedId
    INNER JOIN finances.dbo.simpleBudget b
      ON be.simpleBudgetId = b.simpleBudgetId
      ON t.transactionId = bmt.transactionId
        AND COALESCE(sd.splitTransactionId, 0) = COALESCE(bmt.splitTransactionId, 0)
    WHERE accountingdate BETWEEN @startdate AND @endDate;

  UPDATE s
  SET categoryName = c.categoryName
  FROM staging.factTransaction s
  INNER JOIN Finances.dbo.spendingCategories c
    ON s.categoryId = c.categoryId
  UPDATE staging.factTransaction
  SET categoryName = 'Uncategorized'
  WHERE categoryName IS NULL

  UPDATE s
  SET payeeId = d.payeeId
  FROM staging.factTransaction s
  INNER JOIN dimPayee d
    ON s.description = d.payeeName
  UPDATE s
  SET dateSK = d.dateSK
  FROM staging.factTransaction s
  INNER JOIN dimDate d
    ON s.accountingDate = d.FullDate

  UPDATE s
  SET subcategoryId = v.subcategoryId
  FROM staging.factTransaction s
  INNER JOIN vwCategoryDescription v
    ON s.categoryName = v.categoryName
  UPDATE s
  SET subcategoryId = v.subcategoryId
  FROM staging.factTransaction s
  INNER JOIN vwCategoryDescription v
    ON s.categoryName = v.categoryName + ' - ' + v.subcategoryName

  UPDATE s
  SET subbudgetId = v.subbudgetId
  FROM staging.factTransaction s
  INNER JOIN vwBudgetDescription v
    ON s.budgetLabel1 = v.incomeOrExpense
    AND s.budgetLabel2 = v.budgetName
    AND s.budgetLabel3 = v.subbudgetName

  SELECT
    t.*
  FROM staging.factTransaction t
  INNER JOIN (SELECT
      t.remoteTransactionId
     ,t.remoteTransactionSplitId
    FROM staging.factTransaction t
    GROUP BY t.remoteTransactionId
            ,t.remoteTransactionSplitId
    HAVING COUNT(*) > 1) errors
    ON errors.remoteTransactionId = t.remoteTransactionId
      AND COALESCE(errors.remoteTransactionSplitId, 0) = COALESCE(t.remoteTransactionSplitId, 0)
  ORDER BY 1, 2


  DECLARE @check INT

  SELECT
    @check = COUNT(*)
  FROM (SELECT
           COUNT(*) obs
         FROM staging.factTransaction t) staged
      ,(SELECT
           COUNT(*) obs
         FROM Finances.dbo.bankTransaction t
         LEFT JOIN Finances.dbo.categorySplitDetails sd
           ON t.transactionId = sd.parentTransactionId
         WHERE accountingdate
         BETWEEN @startdate AND @endDate) truth
  WHERE staged.obs - truth.obs <> 0


  IF @check = 0
  BEGIN

    --deletion 1: unsplit transactions now showing as split
    DELETE ft
      FROM dbo.factTransaction ft
      INNER JOIN vwLoadFactTransactionNewSplit v
        ON ft.remoteTransactionId = v.remoteTransactionId

    --deletion 2: splits changed to the point that previously recorded split is invalidated
    DELETE ft
      FROM dbo.factTransaction ft
      INNER JOIN vwLoadFactTransactionDeprecatedSplits v
        ON ft.remoteTransactionId = v.remoteTransactionId
        AND ft.remoteTransactionSplitId = v.remoteTransactionSplitId

    --insert: this will capture all new transactions plus all new splits addressed by deletions 1 and 2
    INSERT INTO dbo.factTransaction (remoteTransactionId, remoteTransactionSplitId, payeeId, subcategoryId, accountId, subbudgetId, dateSK, amount)
      SELECT
        v.remoteTransactionId
       ,v.remoteTransactionSplitId
       ,v.payeeId
       ,v.subcategoryId
       ,v.accountId
       ,v.subbudgetId
       ,v.dateSK
       ,amount
      FROM vwLoadFactTransactionNewTransaction v

    --update details on existing transactions
    UPDATE t
    SET payeeId = v.payeeId
       ,subcategoryId = v.subcategoryId
       ,accountId = v.accountId
       ,subbudgetId = v.subbudgetId
       ,dateSK = v.dateSK
       ,amount = v.amount
    FROM dbo.factTransaction t
    INNER JOIN vwLoadFactTransactionModifiedDetails v
      ON t.remoteTransactionId = v.remoteTransactionId
      AND COALESCE(t.remoteTransactionSplitId, 0) = COALESCE(v.remoteTransactionSplitId, 0)

  END

END