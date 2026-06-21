-- Exported: 2026-06-21T21:55:41.638056+00:00
-- Schema:   dbo
-- Table:    simpleBudgetRule

CREATE TABLE [dbo].[simpleBudgetRule] (
    [simpleBudgetRuleId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [simpleBudgetId] int NOT NULL,
    [ruleIndex] int NOT NULL DEFAULT ((1)),
    [usePayee] int NOT NULL DEFAULT ((0)),
    [useCat] int NOT NULL DEFAULT ((0)),
    [useTag] int NOT NULL DEFAULT ((0)),
    [payeePattern] varchar(255),
    [categoryPattern] varchar(255),
    [tagpattern] varchar(255),
    [effectiveDate] date NOT NULL DEFAULT ('1/1/2015'),
    [retiredDate] date NOT NULL DEFAULT ('12/31/2199'),
    [created_at] datetime NOT NULL DEFAULT (getdate()),
    [created_by] varchar(255) NOT NULL DEFAULT (suser_sname()),
    [updated_at] datetime,
    [updated_by] varchar(255),
    CONSTRAINT [PK_simpleBudgetRule] PRIMARY KEY ([simpleBudgetRuleId])
);

ALTER TABLE [dbo].[simpleBudgetRule] ADD CONSTRAINT [fk_simpleBudgetRule_simpleBudget] FOREIGN KEY ([simpleBudgetId]) REFERENCES [dbo].[simpleBudget] ([simpleBudgetId]);
