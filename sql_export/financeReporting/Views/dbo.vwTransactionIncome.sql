-- Exported: 2026-06-21T21:55:42.312907+00:00
-- Schema:   dbo
-- Object:   vwTransactionIncome
-- Type:     VIEW
-- Created:  2020-01-26 21:45:21.060000
-- Modified: 2020-01-27 00:31:06.750000


CREATE VIEW dbo.vwTransactionIncome
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
 ,e.eventName IncomeTierName
 ,d.DateSK
 ,t.amount
FROM factTransaction t
INNER JOIN dimPayee p
  ON t.payeeId = p.payeeId
INNER JOIN dimDate d
  ON t.dateSK = d.DateSK
INNER JOIN dimAccount a
  ON t.accountId = a.accountId
LEFT JOIN vwDescriptionBudget bd
  ON t.subbudgetId = bd.subbudgetId
LEFT JOIN vwDescriptionCategory cd
  ON t.subcategoryId = cd.subcategoryId
LEFT JOIN (SELECT * FROM dimEvent WHERE eventDomainId=4) e 
  ON t.expenseTierID = e.eventId
WHERE amount>0;
