USE financeReporting
  GO


if object_id('factBudgetMonthlyExpectedSpending') is not null DROP TABLE factBudgetMonthlyExpectedSpending
if object_id('factEventTransaction') is not null DROP TABLE factEventTransaction
if object_id('factTransaction') is not null DROP TABLE factTransaction
if object_id('dimaccount') is not null DROP TABLE dimAccount
if object_id('dimEvent') is not null DROP TABLE dimEvent
if object_id('dimEventDomain') is not null DROP TABLE dimEventDomain
if object_id('dimSubbudget') is not null DROP TABLE dimSubbudget
if object_id('dimBudget') is not null DROP TABLE dimBudget
if object_id('dimSubcategory') is not null DROP TABLE dimSubcategory
if object_id('dimCategory') is not null DROP TABLE dimCategory
if object_id('dimCategoryGroup') is not null DROP TABLE dimCategoryGroup
if object_id('dimPayee') is not null DROP TABLE dimPayee

CREATE TABLE dimPayee (
  payeeId INT IDENTITY (1, 1) PRIMARY KEY
 ,payeeName VARCHAR(255)
)

CREATE TABLE dimCategoryGroup (
  categoryGroupId INT IDENTITY (1, 1) PRIMARY KEY
 ,categoryGroupName VARCHAR(255)
)

CREATE TABLE dimCategory (
  categoryId INT IDENTITY (1, 1) PRIMARY KEY
 ,categoryGroupId INT NOT NULL REFERENCES dimCategoryGroup (categoryGroupId)
 ,categoryName VARCHAR(255)
)

CREATE TABLE dimSubcategory (
  subcategoryId INT IDENTITY (1, 1) PRIMARY KEY
 ,categoryId INT NOT NULL REFERENCES dimCategory (categoryId)
 ,subcategoryName VARCHAR(255)
)

CREATE TABLE dimBudget (
  budgetId INT IDENTITY (1, 1) PRIMARY KEY
  ,incomeOrExpense VARCHAR(255)
 ,budgetName VARCHAR(255)
)

CREATE TABLE dimSubbudget(
    subbudgetId INT IDENTITY(1,1) PRIMARY KEY
  ,budgetId INT NOT NULL REFERENCES dimBudget(budgetId)
  ,subbudgetName varchar(255))

CREATE TABLE dimEventDomain (
  eventDomainId INT IDENTITY (1, 1) PRIMARY KEY
 ,eventDomainName VARCHAR(255)
)

CREATE TABLE dimEvent (
  eventId INT IDENTITY (1, 1) PRIMARY KEY
 ,eventDomainId INT NOT NULL REFERENCES dimEventDomain (eventDomainId)
 ,eventName VARCHAR(255)
)

CREATE TABLE dimAccount (
  accountId INT PRIMARY KEY
 ,accountName VARCHAR(255)
)



CREATE TABLE factTransaction (
  transactionId INT PRIMARY KEY IDENTITY(1,1)
  ,remoteTransactionId INT NOT NULL
  ,remoteTransactionSplitId INT
 ,payeeId INT NOT NULL REFERENCES dimPayee (payeeId)
 ,subcategoryId INT NOT NULL REFERENCES dimSubcategory (subcategoryId)
 ,accountId INT NOT NULL REFERENCES dimAccount (accountId)
 ,subbudgetId INT NULL REFERENCES dimSubbudget (subbudgetId)
 ,dateSK INT NOT NULL REFERENCES DimDate (DateSK)
 ,amount SMALLMONEY
);

CREATE TABLE factEventTransaction (
  eventTransactionId INT IDENTITY (1, 1) PRIMARY KEY
 ,transactionId INT NOT NULL REFERENCES factTransaction (transactionId)
 ,eventId INT NOT NULL REFERENCES dimEvent (eventId)
)

CREATE TABLE factBudgetMonthlyExpectedSpending (
  budgetExpectedSpendingId INT IDENTITY (1, 1) PRIMARY KEY
 ,subbudgetId INT NOT NULL REFERENCES dimSubbudget (subbudgetId)
 ,dateSKStart INT REFERENCES DimDate (dateSK)
 ,amount SMALLMONEY
)

INSERT INTO dimEventDomain (eventDomainName)
  VALUES ('Expense Tiers'),('Significant Events'),('Paper Checks');

SET IDENTITY_INSERT dimCategoryGroup ON 
INSERT INTO dimCategoryGroup (categoryGroupId, categoryGroupName)
  VALUES (0,'Uncategorized');
SET IDENTITY_INSERT dimCategoryGroup OFF

SET IDENTITY_INSERT dimCategory ON 
INSERT INTO dimCategory (categoryId, categoryGroupId, categoryName)
  VALUES (0,0,'Uncategorized');
SET IDENTITY_INSERT dimCategory OFF

SET IDENTITY_INSERT dimSubcategory ON 
  INSERT INTO dimSubcategory(subcategoryId,subcategoryName,categoryId)
    VALUES(0,'',0)
SET IDENTITY_INSERT dimSubcategory OFF

SET IDENTITY_INSERT dimBudget ON
  INSERT INTO dimBudget (budgetId, incomeOrExpense, budgetName)
  VALUES (0,'income', 'Unbudgeted Income'),(-1,'Expenses','Unbudgeted Expenses');
SET IDENTITY_INSERT dimBudget OFF

SET IDENTITY_INSERT dimSubBudget ON
  INSERT INTO dimsubBudget (subbudgetId, budgetId, subbudgetName)
  VALUES (0,0, 'Unbudgeted'),(-1,-1,'Unbudgeted');
SET IDENTITY_INSERT dimsubBudget OFF

