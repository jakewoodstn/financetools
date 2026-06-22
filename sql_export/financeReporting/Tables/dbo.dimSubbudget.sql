-- Exported: 2026-06-21T21:55:42.574126+00:00
-- Schema:   dbo
-- Table:    dimSubbudget

CREATE TABLE [dbo].[dimSubbudget] (
    [subbudgetId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [budgetId] int NOT NULL,
    [subbudgetName] varchar(255),
    CONSTRAINT [PK_dimSubbudget] PRIMARY KEY ([subbudgetId])
);

ALTER TABLE [dbo].[dimSubbudget] ADD CONSTRAINT [FK__dimSubbud__budge__1D4655FB] FOREIGN KEY ([budgetId]) REFERENCES [dbo].[dimBudget] ([budgetId]);
