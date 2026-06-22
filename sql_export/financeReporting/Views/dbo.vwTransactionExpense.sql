-- Exported: 2026-06-21T21:55:42.312618+00:00
-- Schema:   dbo
-- Object:   vwTransactionExpense
-- Type:     VIEW
-- Created:  2020-01-26 21:45:21.190000
-- Modified: 2020-01-27 00:31:06.580000

CREATE VIEW dbo.vwTransactionExpense
AS
SELECT
  t.transactionId
 ,p.payeeName
 ,a.accountName
 ,COALESCE(cd.categoryGroupName,dbo.fn_unknownDisplay()) categoryGroupName
 ,COALESCE(cd.categoryName,dbo.fn_unknownDisplay()) categoryName
 ,COALESCE(cd.subcategoryName,dbo.fn_unknownDisplay()) subcategoryName
 ,COALESCE(bd.budgetName,dbo.fn_unknownDisplay()) budgetName
 ,COALESCE(bd.subbudgetName,dbo.fn_unknownDisplay()) subbudgetName
 ,e.eventName expenseTierName
 ,d.DateSK
 ,t.amount
FROM factTransaction t
INNER JOIN dimPayee p
  ON t.payeeId = p.payeeId
INNER JOIN dimDate d
  ON t.dateSK = d.DateSK
INNER JOIN dimAccount a
  ON t.accountId = a.accountId
Left JOIN vwDescriptionBudget bd
  ON t.subbudgetId = bd.subbudgetId
left JOIN vwDescriptionCategory cd
  ON t.subcategoryId = cd.subcategoryId
LEFT JOIN (SELECT * FROM dimEvent WHERE eventDomainId=1) e 
  ON t.expenseTierID = e.eventId
WHERE amount<0;
