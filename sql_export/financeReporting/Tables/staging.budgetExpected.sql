-- Exported: 2026-06-21T21:55:42.575976+00:00
-- Schema:   staging
-- Table:    budgetExpected

CREATE TABLE [staging].[budgetExpected] (
    [simpleBudgetExpectedId] int,
    [simpleBudgetId] int,
    [transactionStartDate] date,
    [transactionEndDate] date,
    [amount] smallmoney,
    [subbudgetId] int
);

