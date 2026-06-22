-- Exported: 2026-06-21T21:55:42.331497+00:00
-- Schema:   staging
-- Object:   updateStagingBudgetMapping
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2020-06-28 13:03:21.920000
-- Modified: 2020-06-28 13:03:21.920000

CREATE PROC staging.updateStagingBudgetMapping
AS
  BEGIN

    UPDATE s
      SET s.subbudgetId = bm.subbudgetId
      FROM staging.budgetExpected s INNER JOIN staging.vwBudgetMap bm ON s.simpleBudgetId = bm.simpleBudgetId


    UPDATE s
      SET s.subbudgetId = bm.subbudgetId
      FROM staging.budgetRule s INNER JOIN staging.vwBudgetMap bm ON s.simpleBudgetId = bm.simpleBudgetId


  END
