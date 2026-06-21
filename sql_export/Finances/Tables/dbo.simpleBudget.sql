-- Exported: 2026-06-21T21:55:41.637504+00:00
-- Schema:   dbo
-- Table:    simpleBudget

CREATE TABLE [dbo].[simpleBudget] (
    [simpleBudgetId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [label1] varchar(255),
    [label2] varchar(255),
    [label3] varchar(255),
    [created_at] datetime NOT NULL DEFAULT (getdate()),
    [created_by] varchar(255) NOT NULL DEFAULT (suser_sname()),
    [updated_at] datetime,
    [updated_by] varchar(255),
    [sortOrder] int,
    CONSTRAINT [PK_simpleBudget] PRIMARY KEY ([simpleBudgetId])
);

