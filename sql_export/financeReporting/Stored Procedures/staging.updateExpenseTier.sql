-- Exported: 2026-06-21T21:55:42.331107+00:00
-- Schema:   staging
-- Object:   updateExpenseTier
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2020-06-28 13:46:32.630000
-- Modified: 2020-06-28 13:46:32.630000

CREATE PROC staging.updateExpenseTier
AS

BEGIN

  UPDATE staging.factTransaction
  SET expenseTierId = minid
  FROM staging.factTransaction t
  INNER JOIN (SELECT
      t.remoteTransactionId
     ,t.remoteTransactionSplitId
     ,MIN(e.eventId) minId
    FROM staging.factTransaction t
    INNER JOIN staging.eventTransaction et
      ON t.remoteTransactionId = et.remoteTransactionId
      AND COALESCE(t.remoteTransactionSplitId, 0) = COALESCE(et.remoteTransactionSplitid, 0)
    INNER JOIN dimEvent e
      ON et.eventId = e.eventId
    WHERE e.eventDomainId = 1
    GROUP BY t.remoteTransactionId, t.remoteTransactionSplitId
    ) sq
    ON sq.remoteTransactionId = t.remoteTransactionId
    AND COALESCE(sq.remoteTransactionSplitId, 0) = COALESCE(t.remoteTransactionSplitId, 0)

END
