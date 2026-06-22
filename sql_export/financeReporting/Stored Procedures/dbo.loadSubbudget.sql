-- Exported: 2026-06-21T21:55:42.293671+00:00
-- Schema:   dbo
-- Object:   loadSubbudget
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2019-07-12 14:28:10.663000
-- Modified: 2019-07-12 14:30:30.927000


CREATE PROCEDURE loadSubbudget
AS
BEGIN


  INSERT INTO dimSubbudget (budgetId, subbudgetName)
    SELECT
      budgetId
     ,subbudgetName
    FROM vwMissingSubbudget ms
END
