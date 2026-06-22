-- Exported: 2026-06-21T21:55:42.329932+00:00
-- Schema:   staging
-- Object:   stageExpenseTier
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2021-02-07 23:17:59.117000
-- Modified: 2021-02-07 23:17:59.117000


CREATE PROC staging.stageExpenseTier AS
  BEGIN

    UPDATE t SET expenseTierId=e1.expenseTierId
    FROM finances.dbo.transactionTaggedEvent te
        INNER JOIN finances.dbo.taggedEvent e
          ON te.taggedEventId = e.taggedEventId
        INNER JOIN dimExpenseTier e1
          ON e1.expenseTierName = e.taggedEventTag
        INNER JOIN staging.factTransaction t 
          ON te.transactionId = t.remoteTransactionId
            AND COALESCE(te.splitTransactionId, 0) = COALESCE(t.remoteTransactionSplitId, 0)

  END
