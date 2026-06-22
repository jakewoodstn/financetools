-- Exported: 2026-06-21T21:55:42.295184+00:00
-- Schema:   dbo
-- Object:   vwDescriptionBudget
-- Type:     VIEW
-- Created:  2020-01-26 22:05:29.333000
-- Modified: 2020-01-26 22:05:29.333000

CREATE   VIEW dbo.vwDescriptionBudget
AS
  SELECT b.budgetId, s.subbudgetId, b.incomeOrExpense,b.budgetName,s.subbudgetName FROM dimBudget b INNER JOIN dimSubbudget s ON b.budgetId = s.budgetId
