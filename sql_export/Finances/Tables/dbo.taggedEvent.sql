-- Exported: 2026-06-21T21:55:41.639409+00:00
-- Schema:   dbo
-- Table:    taggedEvent

CREATE TABLE [dbo].[taggedEvent] (
    [taggedEventId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [taggedEventTag] varchar(50),
    [taggedEventDescription] varchar(255),
    [effectiveDate] date DEFAULT ('1/1/2011'),
    [retiredDate] date DEFAULT ('12/31/9999'),
    CONSTRAINT [PK_taggedEvent] PRIMARY KEY ([taggedEventId])
);

