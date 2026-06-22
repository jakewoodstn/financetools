-- Exported: 2026-06-21T21:55:42.361349+00:00
-- Schema:   staging
-- Object:   vwImbalancedSplits
-- Type:     VIEW
-- Created:  2021-02-07 22:16:13.883000
-- Modified: 2021-02-07 22:31:56.420000

CREATE VIEW staging.vwImbalancedSplits AS
    SELECT
      btc.transactionId,
      btc.accountingDate,
      btc.amount, 
      SUM(sd.splitAmount) splitTotal
    FROM finances.dbo.BankTransaction btc
    INNER JOIN finances.dbo.categorySplitDetails sd
      ON btc.transactionid = sd.parentTransactionId
    GROUP BY btc.transactionId
            ,btc.amount
            ,btc.accountingDate
    HAVING btc.amount <> SUM(sd.splitAmount)
