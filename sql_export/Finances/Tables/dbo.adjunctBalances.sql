-- Exported: 2026-06-21T21:55:41.634011+00:00
-- Schema:   dbo
-- Table:    adjunctBalances

CREATE TABLE [dbo].[adjunctBalances] (
    [accountId] int NOT NULL,
    [measurementDate] date NOT NULL,
    [balance] smallmoney NOT NULL,
    [income] smallmoney NOT NULL,
    [expense] smallmoney NOT NULL,
    CONSTRAINT [PK_adjunctBalances] PRIMARY KEY ([accountId], [measurementDate])
);

