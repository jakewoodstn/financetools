-- Exported: 2026-06-21T21:55:41.635568+00:00
-- Schema:   dbo
-- Table:    bankTransactionLoad

CREATE TABLE [dbo].[bankTransactionLoad] (
    [transactionId] bigint IDENTITY(b'\x00\xe1\xf5\x05\x00\x00\x00\x00',b'\x01\x00\x00\x00\x00\x00\x00\x00') NOT NULL,
    [transactionStatus] varchar(100),
    [transactionDate] date,
    [OrigDescription] varchar(1000),
    [SplitType] varchar(1000),
    [category] varchar(100),
    [currency] varchar(100),
    [amount] money,
    [UserDescription] varchar(1000),
    [Memo] varchar(max),
    [Classification] varchar(100),
    [account] varchar(100),
    [categoryId] int,
    [accountid] int,
    CONSTRAINT [PK_bankTransactionLoad] PRIMARY KEY ([transactionId])
);

ALTER TABLE [dbo].[bankTransactionLoad] ADD CONSTRAINT [FK__bankTrans__accou__127EAEC5] FOREIGN KEY ([accountid]) REFERENCES [dbo].[account] ([accountId]);
