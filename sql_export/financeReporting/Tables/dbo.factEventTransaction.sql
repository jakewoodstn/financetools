-- Exported: 2026-06-21T21:55:42.575395+00:00
-- Schema:   dbo
-- Table:    factEventTransaction

CREATE TABLE [dbo].[factEventTransaction] (
    [eventTransactionId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [transactionId] int NOT NULL,
    [eventId] int NOT NULL,
    CONSTRAINT [PK_factEventTransaction] PRIMARY KEY ([eventTransactionId])
);

ALTER TABLE [dbo].[factEventTransaction] ADD CONSTRAINT [FK_factEventTransaction_Event] FOREIGN KEY ([eventId]) REFERENCES [dbo].[dimEvent] ([eventId]);
ALTER TABLE [dbo].[factEventTransaction] ADD CONSTRAINT [FK_factEventTransaction_Transaction] FOREIGN KEY ([transactionId]) REFERENCES [dbo].[factTransaction] ([transactionId]);
