-- Exported: 2026-06-21T21:55:42.570497+00:00
-- Schema:   dbo
-- Table:    dimAccount

CREATE TABLE [dbo].[dimAccount] (
    [accountId] int NOT NULL,
    [accountName] varchar(255),
    CONSTRAINT [PK_dimAccount] PRIMARY KEY ([accountId])
);

