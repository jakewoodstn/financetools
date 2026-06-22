-- Exported: 2026-06-21T21:55:42.576639+00:00
-- Schema:   staging
-- Table:    eventTransaction

CREATE TABLE [staging].[eventTransaction] (
    [eventId] int,
    [transactionId] int,
    [remoteTransactionId] int,
    [remoteTransactionSplitid] int,
    [tagId] int,
    [tagName] varchar(255)
);

