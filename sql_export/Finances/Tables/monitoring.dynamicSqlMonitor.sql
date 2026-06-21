-- Exported: 2026-06-21T21:55:41.640461+00:00
-- Schema:   monitoring
-- Table:    dynamicSqlMonitor

CREATE TABLE [monitoring].[dynamicSqlMonitor] (
    [procedureCalling] varchar(255),
    [timeCalled] datetime2,
    [SQLTEXT] nvarchar(max)
);

