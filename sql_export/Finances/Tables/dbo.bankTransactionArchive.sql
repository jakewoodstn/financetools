-- Exported: 2026-06-21T21:55:41.635285+00:00
-- Schema:   dbo
-- Table:    bankTransactionArchive

CREATE TABLE [dbo].[bankTransactionArchive] (
    [transactionId] bigint NOT NULL,
    [transactionDate] date,
    [loadedDate] datetime,
    [description] varchar(1000),
    [category] varchar(100),
    [amount] money,
    [account] varchar(100),
    [categoryId] int,
    [origDescription] varchar(1000),
    [categoryStatus] int NOT NULL,
    [bankOrigDescription] varchar(1000),
    [accountId] int NOT NULL,
    [accountingDate] date,
    [ts] timestamp NOT NULL
);

