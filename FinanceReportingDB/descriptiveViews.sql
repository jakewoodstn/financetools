ALTER VIEW vwBudgetDescription
AS
  SELECT b.budgetId, s.subbudgetId, b.incomeOrExpense,b.budgetName,s.subbudgetName FROM dimBudget b INNER JOIN dimSubbudget s ON b.budgetId = s.budgetId

  GO


ALTER VIEW vwCategoryDescription
  AS
  SELECT cg.categoryGroupId
        ,c.categoryId
        ,s.subcategoryId
        ,cg.categoryGroupName
        ,c.categoryName
        ,s.subcategoryName 
  FROM dimCategoryGroup cg 
    INNER JOIN dimCategory c ON cg.categoryGroupId = c.categoryGroupId 
    LEFT JOIN dimSubcategory s ON c.categoryId = s.categoryId
GO

ALTER VIEW vwEventDescription
  AS
  SELECT ed.eventDomainId
        ,e.eventId
        ,ed.eventDomainName
        ,e.eventName 
  FROM dimEventDomain ed
    INNER JOIN dimEvent e ON ed.eventDomainId = e.eventDomainId
GO

