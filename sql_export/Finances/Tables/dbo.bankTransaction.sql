-- Exported: 2026-06-21T21:55:41.634976+00:00
-- Schema:   dbo
-- Table:    bankTransaction

CREATE TABLE [dbo].[bankTransaction] (
    [transactionId] bigint NOT NULL,
    [transactionDate] date,
    [loadedDate] datetime,
    [description] varchar(1000),
    [category] varchar(100),
    [amount] money,
    [account] varchar(100),
    [categoryId] int,
    [origDescription] varchar(1000),
    [categoryStatus] int NOT NULL DEFAULT ((0)),
    [bankOrigDescription] varchar(1000),
    [accountId] int NOT NULL,
    [accountingDate] date,
    [ts] timestamp NOT NULL,
    CONSTRAINT [PK_bankTransaction] PRIMARY KEY ([transactionId])
);

ALTER TABLE [dbo].[bankTransaction] ADD CONSTRAINT [FK__bankTrans__accou__5BAD9CC8] FOREIGN KEY ([accountId]) REFERENCES [dbo].[account] ([accountId]);
ALTER TABLE [dbo].[bankTransaction] ADD CONSTRAINT [FKCategoryId] FOREIGN KEY ([categoryId]) REFERENCES [dbo].[spendingCategories] ([categoryId]);
