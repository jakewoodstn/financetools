ALTER VIEW vwLoadFactTransactionNewTransaction
  AS
SELECT t.remoteTransactionId
      ,t.remoteTransactionSplitId
      ,t.description
      ,t.payeeId
      ,t.categoryId
      ,t.categoryName
      ,t.subcategoryId
      ,t.accountId
      ,t.budgetLabel1
      ,t.budgetLabel2
      ,t.budgetLabel3
      ,t.subbudgetId
      ,t.accountingDate
      ,t.dateSK
      ,t.amount FROM staging.factTransaction t
  LEFT JOIN dbo.factTransaction tProd ON t.remoteTransactionId = tProd.remoteTransactionId AND COALESCE(t.remoteTransactionSplitId,0) = COALESCE(tprod.remoteTransactionSplitId,0)
  WHERE tprod.transactionId IS NULL
GO

ALTER VIEW vwLoadFactTransactionModifiedDetails AS
  SELECT t.remoteTransactionId
        ,t.remoteTransactionSplitId
        ,t.description
        ,t.payeeId
        ,t.categoryId
        ,t.categoryName
        ,t.subcategoryId
        ,t.accountId
        ,t.budgetLabel1
        ,t.budgetLabel2
        ,t.budgetLabel3
        ,t.subbudgetId
        ,t.accountingDate
        ,t.dateSK
        ,t.amount FROM staging.factTransaction t
  INNER JOIN dbo.factTransaction tProd ON t.remoteTransactionId = tProd.remoteTransactionId AND COALESCE(t.remoteTransactionSplitId,0) = COALESCE(tprod.remoteTransactionSplitId,0)
  WHERE t.payeeId<>tprod.payeeId OR t.subcategoryId <> tprod.subcategoryId OR t.accountId <> tprod.accountId OR t.subbudgetId <> tprod.subbudgetId OR t.dateSK<>tprod.dateSK OR t.amount <> tprod.amount
GO

ALTER VIEW vwLoadFactTransactionNewSplit AS
  SELECT t.remoteTransactionId
        ,t.remoteTransactionSplitId
        ,t.description
        ,t.payeeId
        ,t.categoryId
        ,t.categoryName
        ,t.subcategoryId
        ,t.accountId
        ,t.budgetLabel1
        ,t.budgetLabel2
        ,t.budgetLabel3
        ,t.subbudgetId
        ,t.accountingDate
        ,t.dateSK
        ,t.amount FROM staging.factTransaction t 
      INNER JOIN (SELECT DISTINCT remoteTransactionId FROM dbo.factTransaction tProd WHERE tProd.remoteTransactionSplitId IS NULL) noSplits ON noSplits.remoteTransactionId = t.remoteTransactionId
      WHERE t.remoteTransactionSplitId IS NOT NULL
  GO

ALTER VIEW vwLoadFactTransactionDeprecatedSplits AS
SELECT tProd.*
FROM dbo.factTransaction tProd 
  INNER JOIN dimDate d ON tProd.dateSK = d.DateSK 
  INNER JOIN 
    (SELECT MIN(accountingDate) minDate, MAX(accountingDate) maxDate FROM staging.factTransaction t) guardrails ON d.FullDate BETWEEN guardrails.minDate AND guardrails.maxDate
  LEFT JOIN staging.factTransaction t ON tProd.remoteTransactionId = t.remoteTransactionId AND COALESCE(tProd.remoteTransactionSplitId,0) = COALESCE(t.remoteTransactionSplitId,0)
  WHERE t.remoteTransactionId IS NULL

  GO

