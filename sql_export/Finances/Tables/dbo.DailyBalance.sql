-- Exported: 2026-06-21T21:55:41.636383+00:00
-- Schema:   dbo
-- Table:    DailyBalance

CREATE TABLE [dbo].[DailyBalance] (
    [accountId] int NOT NULL,
    [MeasurementDate] date NOT NULL,
    [Amount] money,
    CONSTRAINT [PK_DailyBalance] PRIMARY KEY ([accountId], [MeasurementDate])
);

