-- Exported: 2026-06-21T21:55:41.639916+00:00
-- Schema:   dbo
-- Table:    transactionEventArchive

CREATE TABLE [dbo].[transactionEventArchive] (
    [transactionTaggedEventId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [transactionId] bigint,
    [taggedEventId] int,
    [taggedAt] date,
    [splitTransactionId] int
);

