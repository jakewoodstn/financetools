-- Exported: 2026-06-21T21:55:41.635839+00:00
-- Schema:   dbo
-- Table:    bankTransactionLoadHx

CREATE TABLE [dbo].[bankTransactionLoadHx] (
    [loadDate] datetime,
    [transactionFile] varchar(1000),
    [transactionId] bigint,
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
    [accountid] int
);

