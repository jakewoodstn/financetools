-- Exported: 2026-06-21T21:55:42.575082+00:00
-- Schema:   dbo
-- Table:    factBudgetRule

CREATE TABLE [dbo].[factBudgetRule] (
    [factBudgetRuleId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [subBudgetId] int NOT NULL,
    [ruleIndex] int NOT NULL,
    [payeeId] int,
    [subcategoryId] int,
    [eventId] int,
    [lastUpdatedAt] datetime2 NOT NULL DEFAULT (sysdatetime()),
    CONSTRAINT [PK_factBudgetRule] PRIMARY KEY ([factBudgetRuleId])
);

ALTER TABLE [dbo].[factBudgetRule] ADD CONSTRAINT [FK__factBudge__subBu__3E3D3572] FOREIGN KEY ([subBudgetId]) REFERENCES [dbo].[dimSubbudget] ([subbudgetId]);
