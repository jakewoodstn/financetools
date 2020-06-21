USE financeReporting
  GO


ALTER VIEW vwMissingAccount AS 
  SELECT accountId, accountName FROM Finances.dbo.account a
    EXCEPT 
  SELECT accountId, accountName FROM dimAccount 
 GO

ALTER VIEW vwMissingBudget AS 
    SELECT DISTINCT label1 incomeOrExpense, label2 budgetName FROM Finances.dbo.simpleBudget b 
    EXCEPT 
    SELECT incomeOrExpense,budgetName FROM dimbudget
GO

ALTER VIEW vwMissingSubbudget AS
  SELECT b1.budgetId, label3 subBudgetName FROM Finances.dbo.simpleBudget b INNER JOIN dimBudget b1 ON b.label2 = b1.budgetName AND b.label1 = b1.incomeOrExpense
  EXCEPT 
  SELECT budgetId,subbudgetName FROM dimSubbudget s
GO

ALTER VIEW vwMissingPayee AS 
   SELECT description payeeName FROM finances.dbo.bankTransaction t
    EXCEPT
   SELECT payeeName FROM dimPayee p
GO

ALTER VIEW vwMissingCategoryGroup AS 
  SELECT groupName categoryGroupName FROM Finances.dbo.spendingCategoryGroup cg
    EXCEPT
  SELECT cg.categoryGroupName FROM dimCategoryGroup cg
GO

ALTER VIEW vwMissingCategory AS 
  SELECT cg.categoryGroupId, sq2.categoryName FROM 
  (SELECT categoryGroupName, categoryName FROM 
    (
      SELECT DISTINCT cg.groupName categoryGroupName, LEFT(c.categoryName,CHARINDEX('-',c.categoryName)-2) categoryName FROM finances.dbo.spendingCategories c INNER JOIN finances.dbo.spendingCategoryGroup cg ON c.groupID = cg.groupID WHERE CHARINDEX('-',categoryName) >0
      UNION SELECT DISTINCT cg.groupName categoryGroupName, c.categoryName FROM finances.dbo.spendingCategories c INNER JOIN finances.dbo.spendingCategoryGroup cg ON c.groupID = cg.groupID WHERE CHARINDEX('-',categoryName) =0
    ) sq
    EXCEPT 
  SELECT categoryGroupName, categoryName FROM dimCategory c INNER JOIN dimCategoryGroup cg ON c.categoryGroupId = cg.categoryGroupId )sq2
  INNER JOIN dimCategoryGroup cg ON sq2.categoryGroupName = cg.categoryGroupName


GO


ALTER VIEW vwMissingSubcategory AS 
  SELECT dc.categoryId, sq2.subcategoryName FROM 
  (SELECT categoryName, subcategoryName FROM 
    (
      SELECT DISTINCT LEFT(c.categoryName,CHARINDEX('-',c.categoryName)-2) categoryName, RIGHT(c.categoryName,LEN(c.categoryName) - CHARINDEX('-',categoryName)-1) subcategoryName FROM finances.dbo.spendingCategories c  WHERE CHARINDEX('-',categoryName) >0
      
    ) sq
    EXCEPT 
  SELECT categoryName, subcategoryName FROM dimSubcategory sc INNER JOIN dimCategory c ON sc.categoryId = c.categoryId) sq2
   INNER JOIN dimCategory dc ON sq2.categoryName=dc.categoryName
GO

ALTER VIEW vwMissingEvent AS 
  SELECT eventDomainId, eventName FROM 
  (
    SELECT DISTINCT 3 eventDomainId, e.taggedEventDescription eventName FROM finances.dbo.taggedEvent e INNER JOIN Finances.dbo.transactionTaggedEvent te ON e.taggedEventId = te.taggedEventId WHERE e.taggedEventDescription LIKE 'Check[0123456789]%'
      EXCEPT 
    SELECT DISTINCT eventDomainId, e.eventName FROM dimEvent e WHERE e.eventDomainId = 3
  ) sq
  UNION
 SELECT eventDomainId, eventName FROM 
  (
    SELECT DISTINCT 1 eventDomainId, e.taggedEventDescription eventName FROM finances.dbo.taggedEvent e INNER JOIN Finances.dbo.transactionTaggedEvent te ON e.taggedEventId = te.taggedEventId WHERE e.taggedEventDescription IN ('Core','Core+','Exception','Flex')
      EXCEPT 
    SELECT DISTINCT eventDomainId, e.eventName FROM dimEvent e WHERE e.eventDomainId = 1
  ) sq
  UNION
   SELECT eventDomainId, eventName FROM 
  (
    SELECT DISTINCT 2 eventDomainId, e.taggedEventDescription eventName FROM finances.dbo.taggedEvent e INNER JOIN Finances.dbo.transactionTaggedEvent te ON e.taggedEventId = te.taggedEventId WHERE e.taggedEventDescription NOT LIKE 'Check[0123456789]%' AND e.taggedEventDescription NOT IN ('Core','Core+','Exception','Flex')
      EXCEPT 
    SELECT DISTINCT eventDomainId, e.eventName FROM dimEvent e WHERE e.eventDomainId = 2
  ) sq

