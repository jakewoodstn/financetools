-- Exported: 2026-06-21T21:55:42.332123+00:00
-- Schema:   staging
-- Object:   vwBudgetMap
-- Type:     VIEW
-- Created:  2020-06-28 12:56:27.493000
-- Modified: 2021-02-06 22:15:44.967000


CREATE VIEW staging.vwBudgetMap
AS
SELECT
  b.simpleBudgetId
 ,db.subbudgetId
FROM finances.dbo.simpleBudget b
INNER JOIN vwDescriptionBudget db
  ON b.label1 = db.incomeOrExpense
    AND b.label2 = db.budgetName
    AND b.label3 = db.subbudgetName
