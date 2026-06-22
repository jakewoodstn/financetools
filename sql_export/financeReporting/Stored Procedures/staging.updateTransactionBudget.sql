-- Exported: 2026-06-21T21:55:42.331845+00:00
-- Schema:   staging
-- Object:   updateTransactionBudget
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2020-06-28 13:32:16.510000
-- Modified: 2020-06-28 13:32:31.527000

CREATE PROC staging.updateTransactionBudget 
AS
BEGIN

  UPDATE s
  SET subbudgetid = sep.subbudgetId
  FROM staging.factTransaction s
  INNER JOIN staging.budgetedSubcategoryEventPayee sep
    ON s.subcategoryId = sep.subcategoryId
    AND s.payeeId = sep.payeeId
  INNER JOIN staging.eventTransaction et
    ON sep.eventId = et.eventId
    AND s.remoteTransactionId = et.remoteTransactionId
    AND COALESCE(s.remoteTransactionSplitId, 0) = COALESCE(et.remoteTransactionSplitid, 0)

  UPDATE s
  SET subbudgetid = ps.subbudgetid
  FROM staging.factTransaction s
  INNER JOIN staging.budgetedPayeeSubcategory ps
    ON s.payeeId = ps.payeeId
    AND s.subcategoryId = ps.subcategoryId
  WHERE s.subbudgetId IS NULL

  UPDATE s
  SET subbudgetid = pe.subbudgetid
  FROM staging.factTransaction s
  INNER JOIN staging.budgetedPayeeEvent pe
    ON s.payeeId = pe.payeeId
  INNER JOIN staging.eventTransaction et
    ON pe.eventId = et.eventId
    AND s.remoteTransactionId = et.remoteTransactionId
    AND COALESCE(s.remoteTransactionSplitId, 0) = COALESCE(et.remoteTransactionSplitid, 0)
  WHERE s.subbudgetId IS NULL


  UPDATE s
  SET subbudgetid = se.subbudgetid
  FROM staging.factTransaction s
  INNER JOIN staging.budgetedSubcategoryEvent se
    ON s.subcategoryId = se.subcategoryId
  INNER JOIN staging.eventTransaction et
    ON se.eventId = et.eventId
    AND s.remoteTransactionId = et.remoteTransactionId
    AND COALESCE(s.remoteTransactionSplitId, 0) = COALESCE(et.remoteTransactionSplitid, 0)
  WHERE s.subbudgetId IS NULL


  UPDATE s
  SET subbudgetId = p.subBudgetId
  FROM staging.factTransaction s
  INNER JOIN staging.budgetedPayee p
    ON s.payeeId = p.payeeId
  WHERE s.subBudgetId IS NULL

  UPDATE s
  SET subbudgetid = sc.subbudgetid
  FROM staging.factTransaction s
  INNER JOIN staging.budgetedSubcategory sc
    ON s.subcategoryId = sc.subcategoryId
  WHERE s.subbudgetId IS NULL


  UPDATE s
  SET subbudgetid = e.subbudgetid
  FROM staging.factTransaction s
  INNER JOIN staging.eventTransaction et
    ON s.remoteTransactionId = et.remoteTransactionId
    AND COALESCE(s.remoteTransactionSplitId, 0) = COALESCE(et.remoteTransactionSplitid, 0)
  INNER JOIN staging.budgetedEvent e
    ON e.eventId = et.eventId
  WHERE s.subbudgetId IS NULL

END
