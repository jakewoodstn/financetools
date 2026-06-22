-- Exported: 2026-06-21T21:55:42.577469+00:00
-- Schema:   staging
-- Table:    factTransaction

CREATE TABLE [staging].[factTransaction] (
    [remoteTransactionId] int,
    [remoteTransactionSplitId] int,
    [description] varchar(255),
    [payeeId] int,
    [categoryId] int,
    [categoryName] varchar(255),
    [subcategoryId] int,
    [accountId] int,
    [subbudgetId] int,
    [accountingDate] varchar(10),
    [dateSK] int,
    [amount] smallmoney,
    [expenseTierId] int
);

