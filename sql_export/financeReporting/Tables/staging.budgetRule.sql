-- Exported: 2026-06-21T21:55:42.576296+00:00
-- Schema:   staging
-- Table:    budgetRule

CREATE TABLE [staging].[budgetRule] (
    [simpleBudgetRuleId] int NOT NULL,
    [simpleBudgetId] int,
    [ruleIndex] int NOT NULL DEFAULT ((1)),
    [usePayee] int NOT NULL DEFAULT ((0)),
    [useCat] int NOT NULL DEFAULT ((0)),
    [useTag] int NOT NULL DEFAULT ((0)),
    [payeePattern] varchar(255),
    [categoryPattern] varchar(255),
    [tagpattern] varchar(255),
    [effectiveDate] date NOT NULL DEFAULT ('1/1/2015'),
    [retiredDate] date NOT NULL DEFAULT ('12/31/2199'),
    [subbudgetId] int,
    CONSTRAINT [PK_budgetRule] PRIMARY KEY ([simpleBudgetRuleId])
);

