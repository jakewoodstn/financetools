-- Exported: 2026-06-21T21:55:41.637786+00:00
-- Schema:   dbo
-- Table:    simpleBudgetExpected

CREATE TABLE [dbo].[simpleBudgetExpected] (
    [simpleBudgetExpectedId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [simpleBudgetId] int,
    [amount] smallmoney,
    [transactionStartDate] date,
    [transactionEndDate] date DEFAULT ('12/31/2199'),
    [effectiveDate] date,
    [retiredDate] date DEFAULT ('12/31/2199'),
    CONSTRAINT [PK_simpleBudgetExpected] PRIMARY KEY ([simpleBudgetExpectedId])
);

ALTER TABLE [dbo].[simpleBudgetExpected] ADD CONSTRAINT [FK_simpleBudgetExpected_simpleBudget_simpleBudgetId] FOREIGN KEY ([simpleBudgetId]) REFERENCES [dbo].[simpleBudget] ([simpleBudgetId]);
