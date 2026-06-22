-- Exported: 2026-06-21T21:55:42.316220+00:00
-- Schema:   staging
-- Object:   calculateBudgetToTransactionMaps
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2020-06-28 13:07:56.130000
-- Modified: 2020-06-28 13:07:56.130000

CREATE PROC staging.calculateBudgetToTransactionMaps

AS

BEGIN


  TRUNCATE TABLE staging.budgetedPayee
  INSERT INTO staging.budgetedPayee (subBudgetId, payeeId)
    SELECT
      r.subBudgetId
     ,p.payeeId
    FROM staging.budgetRule r
    INNER JOIN dimPayee p
      ON p.payeeName LIKE r.payeePattern
    WHERE r.usePayee = 1
    AND r.useCat = 0
    AND r.useTag = 0

  TRUNCATE TABLE staging.budgetedSubcategory

  INSERT INTO staging.budgetedSubcategory (subBudgetId, subcategoryId)
    SELECT
      r.subBudgetId
     ,dc.subcategoryId
    FROM staging.budgetRule r
    INNER JOIN vwDescriptionCategory dc
      ON dc.categoryName + ' - ' + dc.subcategoryName LIKE r.categoryPattern
    WHERE r.useCat = 1
    AND r.usePayee = 0
    AND r.useTag = 0


  TRUNCATE TABLE staging.budgetedEvent
  INSERT INTO staging.budgetedEvent (subBudgetId, eventId)
    SELECT
      r.subBudgetId
     ,e.eventId
    FROM staging.budgetRule r
    INNER JOIN dimEvent e
      ON e.eventName LIKE r.tagpattern
    WHERE r.useTag = 1
    AND r.usePayee = 0
    AND r.useCat = 0

  TRUNCATE TABLE staging.budgetedPayeeSubcategory

  INSERT INTO staging.budgetedPayeeSubcategory (subbudgetid, payeeId, subcategoryId)
    SELECT
      r.subBudgetId
     ,p.payeeId
     ,dc.subcategoryId
    FROM staging.budgetRule r
    INNER JOIN vwDescriptionCategory dc
      ON dc.categoryName + ' - ' + dc.subcategoryName LIKE r.categoryPattern
    INNER JOIN dimPayee p
      ON p.payeeName LIKE r.payeePattern
    WHERE r.useCat = 1
    AND r.usePayee = 1
    AND r.useTag = 0


  TRUNCATE TABLE staging.budgetedPayeeEvent

  INSERT INTO staging.budgetedPayeeEvent (subbudgetId, payeeId, eventId)
    SELECT
      r.subBudgetId
     ,p.payeeId
     ,e.eventId
    FROM staging.budgetRule r
    INNER JOIN dimEvent e
      ON e.eventName LIKE r.tagpattern
    INNER JOIN dimPayee p
      ON p.payeeName LIKE r.payeePattern
    WHERE r.useCat = 0
    AND r.usePayee = 1
    AND r.useTag = 1


  TRUNCATE TABLE staging.budgetedSubcategoryEvent

  INSERT INTO staging.budgetedSubcategoryEvent (subbudgetId, subcategoryId, eventId)
    SELECT
      r.subBudgetId
     ,dc.subcategoryId
     ,e.eventId
    FROM staging.budgetRule r
    INNER JOIN vwDescriptionCategory dc
      ON dc.categoryName + ' - ' + dc.subcategoryName LIKE r.categoryPattern
    INNER JOIN dimEvent e
      ON e.eventName LIKE r.tagpattern
    WHERE r.useCat = 1
    AND r.usePayee = 0
    AND r.useTag = 1

  TRUNCATE TABLE staging.budgetedSubcategoryEventPayee

  INSERT INTO staging.budgetedSubcategoryEventPayee (subbudgetId, subcategoryId, eventId, payeeId)
    SELECT
      r.subBudgetId
     ,dc.subcategoryId
     ,e.eventId
     ,p.payeeId
    FROM staging.budgetRule r
    INNER JOIN dimPayee p
      ON p.payeeName LIKE r.payeePattern
    INNER JOIN vwDescriptionCategory dc
      ON dc.categoryName + ' - ' + dc.subcategoryName LIKE r.categoryPattern
    INNER JOIN dimEvent e
      ON e.eventName LIKE r.tagpattern
    WHERE r.useCat = 1
    AND r.usePayee = 1
    AND r.useTag = 1


END
