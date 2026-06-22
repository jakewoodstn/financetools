-- Exported: 2026-06-21T21:55:42.267848+00:00
-- Schema:   dbo
-- Object:   loadBudget
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2019-07-12 14:28:10.660000
-- Modified: 2019-07-12 14:30:30.920000


CREATE PROCEDURE loadBudget
AS
BEGIN

  INSERT INTO dimBudget (incomeORExpense, budgetName)
    SELECT
      incomeOrExpense
     ,budgetName
    FROM vwMissingBudget mb

END
