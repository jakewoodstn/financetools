-- Exported: 2026-06-21T21:55:41.641251+00:00
-- Schema:   raw
-- Table:    imported

CREATE TABLE [raw].[imported] (
    [import_id] int NOT NULL,
    [filename] varchar(1000),
    [import_date] datetime2,
    CONSTRAINT [PK_imported] PRIMARY KEY ([import_id])
);

