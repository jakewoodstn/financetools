-- Exported: 2026-06-21T21:55:41.638581+00:00
-- Schema:   dbo
-- Table:    spendingCategoryGroup

CREATE TABLE [dbo].[spendingCategoryGroup] (
    [groupID] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [groupName] varchar(50) NOT NULL,
    CONSTRAINT [PK_spendingCategoryGroup] PRIMARY KEY ([groupID])
);

