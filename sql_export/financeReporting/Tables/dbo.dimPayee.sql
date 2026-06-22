-- Exported: 2026-06-21T21:55:42.573850+00:00
-- Schema:   dbo
-- Table:    dimPayee

CREATE TABLE [dbo].[dimPayee] (
    [payeeId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [payeeName] varchar(255),
    CONSTRAINT [PK_dimPayee] PRIMARY KEY ([payeeId])
);

