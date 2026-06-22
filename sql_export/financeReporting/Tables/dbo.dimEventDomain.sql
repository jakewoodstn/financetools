-- Exported: 2026-06-21T21:55:42.573232+00:00
-- Schema:   dbo
-- Table:    dimEventDomain

CREATE TABLE [dbo].[dimEventDomain] (
    [eventDomainId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [eventDomainName] varchar(255),
    CONSTRAINT [PK_dimEventDomain] PRIMARY KEY ([eventDomainId])
);

