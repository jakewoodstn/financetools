-- Exported: 2026-06-21T21:55:41.640196+00:00
-- Schema:   dbo
-- Table:    transactionTaggedEvent

CREATE TABLE [dbo].[transactionTaggedEvent] (
    [transactionTaggedEventId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [transactionId] bigint,
    [taggedEventId] int,
    [taggedAt] date DEFAULT (getdate()),
    [splitTransactionId] int,
    CONSTRAINT [PK_transactionTaggedEvent] PRIMARY KEY ([transactionTaggedEventId])
);

ALTER TABLE [dbo].[transactionTaggedEvent] ADD CONSTRAINT [fk_transactionEvent_Event] FOREIGN KEY ([taggedEventId]) REFERENCES [dbo].[taggedEvent] ([taggedEventId]);
ALTER TABLE [dbo].[transactionTaggedEvent] ADD CONSTRAINT [fk_transactionEvent_transaction] FOREIGN KEY ([transactionId]) REFERENCES [dbo].[bankTransaction] ([transactionId]);
