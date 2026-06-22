-- Exported: 2026-06-21T21:55:42.575717+00:00
-- Schema:   dbo
-- Table:    factTransaction

CREATE TABLE [dbo].[factTransaction] (
    [transactionId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [remoteTransactionId] int NOT NULL,
    [remoteTransactionSplitId] int,
    [payeeId] int NOT NULL,
    [subcategoryId] int NOT NULL,
    [accountId] int NOT NULL,
    [subbudgetId] int,
    [expenseTierID] int,
    [dateSK] int NOT NULL,
    [amount] smallmoney,
    [lastUpdated] datetime2 NOT NULL DEFAULT (sysdatetime()),
    CONSTRAINT [PK_factTransaction] PRIMARY KEY ([transactionId])
);

ALTER TABLE [dbo].[factTransaction] ADD CONSTRAINT [FK__factTrans__accou__1A34DF26] FOREIGN KEY ([accountId]) REFERENCES [dbo].[dimAccount] ([accountId]);
ALTER TABLE [dbo].[factTransaction] ADD CONSTRAINT [FK__factTrans__dateS__1940BAED] FOREIGN KEY ([dateSK]) REFERENCES [dbo].[dimDate] ([DateSK]);
ALTER TABLE [dbo].[factTransaction] ADD CONSTRAINT [FK__factTrans__payee__184C96B4] FOREIGN KEY ([payeeId]) REFERENCES [dbo].[dimPayee] ([payeeId]);
ALTER TABLE [dbo].[factTransaction] ADD CONSTRAINT [FK__factTrans__subbu__1758727B] FOREIGN KEY ([subbudgetId]) REFERENCES [dbo].[dimSubbudget] ([subbudgetId]);
ALTER TABLE [dbo].[factTransaction] ADD CONSTRAINT [FK__factTrans__subca__16644E42] FOREIGN KEY ([subcategoryId]) REFERENCES [dbo].[dimSubcategory] ([subcategoryId]);
ALTER TABLE [dbo].[factTransaction] ADD CONSTRAINT [FK_factTransaction_expenseTierEvent] FOREIGN KEY ([expenseTierID]) REFERENCES [dbo].[dimExpenseTier] ([expenseTierId]);
