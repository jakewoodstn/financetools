-- Exported: 2026-06-21T21:55:41.633455+00:00
-- Schema:   dbo
-- Table:    account

CREATE TABLE [dbo].[account] (
    [accountId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [accountName] nvarchar(50),
    [createdAt] date,
    [closedOn] date,
    [importTransactions] tinyint,
    [ts] timestamp NOT NULL,
    CONSTRAINT [PK_account] PRIMARY KEY ([accountId])
);

