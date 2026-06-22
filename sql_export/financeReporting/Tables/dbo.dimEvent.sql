-- Exported: 2026-06-21T21:55:42.572864+00:00
-- Schema:   dbo
-- Table:    dimEvent

CREATE TABLE [dbo].[dimEvent] (
    [eventId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [eventDomainId] int NOT NULL,
    [eventName] varchar(255),
    CONSTRAINT [PK_dimEvent] PRIMARY KEY ([eventId])
);

ALTER TABLE [dbo].[dimEvent] ADD CONSTRAINT [FK__dimEvent__eventD__220B0B18] FOREIGN KEY ([eventDomainId]) REFERENCES [dbo].[dimEventDomain] ([eventDomainId]);
