-- Exported: 2026-06-21T21:55:41.638851+00:00
-- Schema:   dbo
-- Table:    splitArchive

CREATE TABLE [dbo].[splitArchive] (
    [splitTransactionId] bigint IDENTITY(b'\x01\x00\x00\x00\x00\x00\x00\x00',b'\x01\x00\x00\x00\x00\x00\x00\x00') NOT NULL,
    [parentTransactionId] bigint,
    [categoryId] int,
    [splitAmount] money
);

