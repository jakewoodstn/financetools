/*IGNORE
        dimDate
        dimExceptionTier
        dimEventDomain
*/

USE financeReporting
GO

declare @fullLoad INT =1
IF @fullLoad>0
BEGIN

TRUNCATE TABLE staging.eventTransaction
TRUNCATE TABLE staging.budgetRule
TRUNCATE TABLE staging.budgetExpected
TRUNCATE TABLE staging.factTransaction
TRUNCATE TABLE staging.validationDateRange
TRUNCATE TABLE factBudgetRule
TRUNCATE TABLE factEventTransaction
TRUNCATE TABLE factBudgetExpectedSpending

DELETE factTransaction
DELETE dimPayee
DELETE dimSubcategory WHERE subcategoryId>0
DELETE dimCategory WHERE categoryId>0
DELETE dimCategoryGroup WHERE categoryGroupId>0
DELETE dimSubbudget
DELETE dimBudget
DELETE dimEvent
DELETE dimAccount

DBCC CHECKIDENT (factTransaction, RESEED, 0) WITH NO_INFOMSGS
DBCC CHECKIDENT (dimCategoryGroup, RESEED, 0)WITH NO_INFOMSGS
DBCC CHECKIDENT (dimCategory, RESEED, 0)WITH NO_INFOMSGS
DBCC CHECKIDENT (dimSubcategory, RESEED, 0)WITH NO_INFOMSGS
DBCC CHECKIDENT (dimBudget, RESEED, 0)WITH NO_INFOMSGS
DBCC CHECKIDENT (dimPayee, RESEED, 0)WITH NO_INFOMSGS
DBCC CHECKIDENT (dimSubbudget, RESEED, 0)WITH NO_INFOMSGS
DBCC CHECKIDENT (dimEventDomain, RESEED, 0)WITH NO_INFOMSGS
DBCC CHECKIDENT (dimEvent, RESEED, 0)WITH NO_INFOMSGS

END

EXEC loadWarehouse '1/1/2019','12/31/2022'

GO
