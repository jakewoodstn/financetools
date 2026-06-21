-- Exported: 2026-06-21T21:55:41.639663+00:00
-- Schema:   dbo
-- Table:    transactionAccount

CREATE TABLE [dbo].[transactionAccount] (
    [accountId] int,
    [transactionAccountName] nvarchar(255) NOT NULL,
    CONSTRAINT [PK_transactionAccount] PRIMARY KEY ([transactionAccountName])
);

ALTER TABLE [dbo].[transactionAccount] ADD CONSTRAINT [taAccountFK] FOREIGN KEY ([accountId]) REFERENCES [dbo].[account] ([accountId]);
