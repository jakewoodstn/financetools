-- Exported: 2026-06-21T21:55:42.297399+00:00
-- Schema:   dbo
-- Object:   vwMissingBudget
-- Type:     VIEW
-- Created:  2019-05-06 16:13:21.133000
-- Modified: 2019-05-06 17:03:59.167000


CREATE VIEW vwMissingBudget AS 
    SELECT DISTINCT label1 incomeOrExpense, label2 budgetName FROM Finances.dbo.simpleBudget b 
    EXCEPT 
    SELECT incomeOrExpense,budgetName FROM dimbudget
