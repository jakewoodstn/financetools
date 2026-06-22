-- Exported: 2026-06-21T21:55:42.311764+00:00
-- Schema:   dbo
-- Object:   vwMissingSubbudget
-- Type:     VIEW
-- Created:  2019-05-06 16:17:14.200000
-- Modified: 2019-05-06 17:03:59.213000


CREATE VIEW vwMissingSubbudget AS
  SELECT b1.budgetId, label3 subBudgetName FROM Finances.dbo.simpleBudget b INNER JOIN dimBudget b1 ON b.label2 = b1.budgetName AND b.label1 = b1.incomeOrExpense
  EXCEPT 
  SELECT budgetId,subbudgetName FROM dimSubbudget s
