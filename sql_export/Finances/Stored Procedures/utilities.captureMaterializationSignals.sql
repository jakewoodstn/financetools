-- Exported: 2026-06-21T21:55:41.449013+00:00
-- Schema:   utilities
-- Object:   captureMaterializationSignals
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2017-05-10 06:05:57.343000
-- Modified: 2020-06-21 22:37:53.743000

CREATE PROCEDURE captureMaterializationSignals
  AS
  BEGIN

TRUNCATE table simpleBudgetMaterializationSignals
    
    INSERT INTO simpleBudgetMaterializationSignals (signalName, signalValue)
    SELECT 'TotalRecordCount', COUNT(*) FROM BankTransactionCat btc
  
    INSERT INTO simpleBudgetMaterializationSignals (signalName, signalValue)
    SELECT 'TotalTaggedEventCount', COUNT(*) FROM transactionTaggedEvent te

    INSERT INTO simpleBudgetMaterializationSignals (signalName, signalValue)
    SELECT 'CatCount: ' + COALESCE(btc.categoryName,'Uncategorized'), COUNT(*) from BankTransactionCat btc GROUP by btc.categoryName

    INSERT INTO simpleBudgetMaterializationSignals (signalName, signalValue)
    SELECT 'DateCount: ' + COALESCE(dd.ActDate,'000000'), COUNT(*) from BankTransactionCat btc INNER JOIN DimDate dd ON btc.accountingDate = dd.FullDate GROUP by actdate 

END
