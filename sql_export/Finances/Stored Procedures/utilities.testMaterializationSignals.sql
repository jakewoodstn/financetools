-- Exported: 2026-06-21T21:55:41.469747+00:00
-- Schema:   utilities
-- Object:   testMaterializationSignals
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2017-05-10 06:14:54.080000
-- Modified: 2020-06-21 22:37:45.097000

CREATE PROCEDURE testMaterializationSignals
AS
BEGIN

  SET NOCOUNT ON;

  SELECT
    signalType,
    1 indicator
  FROM (SELECT
    'TotalRecordCount' signalType,
    COUNT(*) obs
  FROM BankTransactionCat btc
  EXCEPT
  SELECT
    signalName,
    signalValue
  FROM simpleBudgetMaterializationSignals bms) total
  UNION

  SELECT
    signalType,
    1
  FROM (SELECT
    'TotalTaggedEventCount ' signalType,
    COUNT(*) obs
  FROM transactionTaggedEvent te
  EXCEPT
  SELECT
    signalName,
    signalValue
  FROM simpleBudgetMaterializationSignals bms) tags
  UNION

  SELECT
    'Category',
    1
  FROM (SELECT
    'CatCount: ' + COALESCE(btc.categoryName, 'Uncategorized') signalType,
    COUNT(*) obs
  FROM BankTransactionCat btc
  GROUP BY btc.categoryName
  EXCEPT
  SELECT
    signalName,
    signalValue
  FROM simpleBudgetMaterializationSignals bms) cats


  UNION
  SELECT
    'AccountingDate',
    1
  FROM (SELECT
    'DateCount: ' + dd.ActDate signalType,
    COUNT(*) obs
  FROM BankTransactionCat btc
  INNER JOIN DimDate dd
    ON btc.accountingDate = dd.FullDate
  GROUP BY dd.ActDate
  EXCEPT
  SELECT
    signalName,
    signalValue
  FROM simpleBudgetMaterializationSignals bms) acctDates

END
