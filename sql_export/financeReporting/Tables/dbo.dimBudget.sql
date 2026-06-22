-- Exported: 2026-06-21T21:55:42.571220+00:00
-- Schema:   dbo
-- Table:    dimBudget

CREATE TABLE [dbo].[dimBudget] (
    [budgetId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [incomeOrExpense] varchar(255),
    [budgetName] varchar(255),
    CONSTRAINT [PK_dimBudget] PRIMARY KEY ([budgetId])
);

