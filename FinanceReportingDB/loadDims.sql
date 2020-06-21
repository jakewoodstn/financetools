USE financereporting
GO


ALTER PROCEDURE loadAccount
AS
BEGIN

  INSERT INTO dimAccount (accountId, accountName)
    SELECT
      *
    FROM vwMissingAccount;
END
GO

ALTER PROCEDURE loadBudget
AS
BEGIN

  INSERT INTO dimBudget (incomeORExpense, budgetName)
    SELECT
      incomeOrExpense
     ,budgetName
    FROM vwMissingBudget mb

END
GO

ALTER PROCEDURE loadSubbudget
AS
BEGIN


  INSERT INTO dimSubbudget (budgetId, subbudgetName)
    SELECT
      budgetId
     ,subbudgetName
    FROM vwMissingSubbudget ms
END
GO

ALTER PROCEDURE loadPayee
AS
BEGIN

  INSERT INTO dimPayee (payeeName)
    SELECT
      payeename
    FROM vwMissingPayee
END
GO

ALTER PROCEDURE loadCategoryGroup
AS
BEGIN
  INSERT INTO dimCategoryGroup (categoryGroupName)
    SELECT
      categoryGroupName
    FROM vwMissingCategoryGroup
END
GO

ALTER PROCEDURE loadCategory
AS
BEGIN

  INSERT INTO dimCategory (categoryGroupId, categoryName)
    SELECT
      categoryGroupId
     ,categoryName
    FROM vwMissingCategory
END
GO

ALTER PROCEDURE loadSubcategory
AS
BEGIN

  INSERT INTO dimSubcategory (categoryId, subcategoryName)
    SELECT
      categoryId
     ,subcategoryName
    FROM vwMissingSubcategory

  INSERT INTO dimSubcategory (categoryId, subcategoryName)
    SELECT
      categoryId
     ,''
    FROM vwCategoryDescription
    WHERE subCategoryName IS NULL
END

GO

ALTER PROCEDURE loadEvent
AS
BEGIN

  INSERT INTO dimEvent (eventDomainId, eventName)
    SELECT
      eventDomainId
     ,eventName
    FROM vwMissingEvent
END

GO

ALTER PROCEDURE loadDimensions
AS
BEGIN

  SET NOCOUNT ON

  EXEC loadAccount
  EXEC loadBudget
  EXEC loadSubbudget
  EXEC loadPayee
  EXEC loadCategoryGroup
  EXEC loadCategory
  EXEC loadSubcategory
  EXEC loadEvent

END