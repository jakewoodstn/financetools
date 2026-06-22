-- Exported: 2026-06-21T21:55:42.329546+00:00
-- Schema:   staging
-- Object:   stageEventTransactionFact
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2020-06-28 13:16:03.013000
-- Modified: 2021-02-07 19:51:59.017000


CREATE PROC staging.stageEventTransactionFact
  AS

  BEGIN
  TRUNCATE TABLE staging.eventTransaction

  INSERT INTO staging.eventTransaction (eventId, transactionId,remoteTransactionId, remoteTransactionSplitid, tagId, tagName)
    SELECT
      e1.eventId
     ,null
     ,t.remoteTransactionId
     ,t.remoteTransactionSplitId
     ,te.taggedEventId
     ,e.taggedEventTag
    FROM finances.dbo.transactionTaggedEvent te
    INNER JOIN finances.dbo.taggedEvent e
      ON te.taggedEventId = e.taggedEventId
    INNER JOIN dimEvent e1
      ON e1.eventName = e.taggedEventTag
    INNER JOIN staging.factTransaction t 
      ON te.transactionId = t.remoteTransactionId
        AND COALESCE(te.splitTransactionId, 0) = COALESCE(t.remoteTransactionSplitId, 0)
  END
