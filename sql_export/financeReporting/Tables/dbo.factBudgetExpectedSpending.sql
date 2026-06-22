-- Exported: 2026-06-21T21:55:42.574790+00:00
-- Schema:   dbo
-- Table:    factBudgetExpectedSpending

CREATE TABLE [dbo].[factBudgetExpectedSpending] (
    [budgetExpectedSpendingId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [subbudgetId] int NOT NULL,
    [dateSKStart] int NOT NULL,
    [dateSKEnd] int,
    [amountMonth] smallmoney,
    [amountQuarter] smallmoney,
    [amountYear] smallmoney,
    CONSTRAINT [PK_factBudgetExpectedSpending] PRIMARY KEY ([budgetExpectedSpendingId])
);

ALTER TABLE [dbo].[factBudgetExpectedSpending] ADD CONSTRAINT [FK__factBudge__dateS__45DE573A] FOREIGN KEY ([dateSKStart]) REFERENCES [dbo].[dimDate] ([DateSK]);
ALTER TABLE [dbo].[factBudgetExpectedSpending] ADD CONSTRAINT [FK__factBudge__subbu__44EA3301] FOREIGN KEY ([subbudgetId]) REFERENCES [dbo].[dimSubbudget] ([subbudgetId]);
