-- Exported: 2026-06-21T21:55:42.294250+00:00
-- Schema:   dbo
-- Object:   loadTransactionFact
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2019-07-12 14:35:11.063000
-- Modified: 2021-02-07 19:41:49.673000

CREATE PROCEDURE dbo.loadTransactionFact 

AS
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
    INSERT INTO dbo.factTransaction (remoteTransactionId, remoteTransactionSplitId, payeeId, subcategoryId, accountId, subbudgetId, dateSK, expenseTierId, amount)
      SELECT
        v.remoteTransactionId
       ,v.remoteTransactionSplitId
       ,v.payeeId
       ,v.subcategoryId
       ,v.accountId
       ,v.subbudgetId
       ,v.dateSK
       ,v.expenseTierId
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
      ,expenseTierID = v.expenseTierId
    FROM dbo.factTransaction t
    INNER JOIN vwLoadFactTransactionModifiedDetails v
      ON t.remoteTransactionId = v.remoteTransactionId
      AND COALESCE(t.remoteTransactionSplitId, 0) = COALESCE(v.remoteTransactionSplitId, 0)

      
   --apply new identity values back to transactions for event update
      
     UPDATE t
        SET transactionId=t1.transactionId
        FROM staging.eventTransaction t INNER JOIN factTransaction t1
        ON t.remoteTransactionId = t1.remoteTransactionId AND COALESCE(t.remoteTransactionSplitid,0) = COALESCE(t1.remoteTransactionSplitId,0)
     
END
