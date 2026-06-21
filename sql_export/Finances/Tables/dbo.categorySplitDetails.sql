-- Exported: 2026-06-21T21:55:41.636113+00:00
-- Schema:   dbo
-- Table:    categorySplitDetails

CREATE TABLE [dbo].[categorySplitDetails] (
    [splitTransactionId] bigint IDENTITY(b'\x01\x00\x00\x00\x00\x00\x00\x00',b'\x01\x00\x00\x00\x00\x00\x00\x00') NOT NULL,
    [parentTransactionId] bigint,
    [categoryId] int,
    [splitAmount] money,
    CONSTRAINT [PK_categorySplitDetails] PRIMARY KEY ([splitTransactionId])
);

ALTER TABLE [dbo].[categorySplitDetails] ADD CONSTRAINT [FK__categoryS__categ__1372D2FE] FOREIGN KEY ([categoryId]) REFERENCES [dbo].[spendingCategories] ([categoryId]);
ALTER TABLE [dbo].[categorySplitDetails] ADD CONSTRAINT [FK__categoryS__paren__1466F737] FOREIGN KEY ([parentTransactionId]) REFERENCES [dbo].[bankTransaction] ([transactionId]);
