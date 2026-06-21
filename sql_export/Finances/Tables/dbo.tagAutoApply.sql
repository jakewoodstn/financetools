-- Exported: 2026-06-21T21:55:41.639135+00:00
-- Schema:   dbo
-- Table:    tagAutoApply

CREATE TABLE [dbo].[tagAutoApply] (
    [tagAutoApplyId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [tagIdTriggering] int,
    [tagIdToApply] int,
    CONSTRAINT [PK_tagAutoApply] PRIMARY KEY ([tagAutoApplyId])
);

ALTER TABLE [dbo].[tagAutoApply] ADD CONSTRAINT [tagIdToApplyFKTagID] FOREIGN KEY ([tagIdToApply]) REFERENCES [dbo].[taggedEvent] ([taggedEventId]);
ALTER TABLE [dbo].[tagAutoApply] ADD CONSTRAINT [tagIdTriggeringFKTagID] FOREIGN KEY ([tagIdTriggering]) REFERENCES [dbo].[taggedEvent] ([taggedEventId]);
