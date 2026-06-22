-- Exported: 2026-06-21T21:55:42.573561+00:00
-- Schema:   dbo
-- Table:    dimExpenseTier

CREATE TABLE [dbo].[dimExpenseTier] (
    [expenseTierId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [expenseTierName] varchar(255),
    CONSTRAINT [PK_dimExpenseTier] PRIMARY KEY ([expenseTierId])
);

