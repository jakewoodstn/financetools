-- Exported: 2026-06-21T21:55:42.572035+00:00
-- Schema:   dbo
-- Table:    dimCategoryGroup

CREATE TABLE [dbo].[dimCategoryGroup] (
    [categoryGroupId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [categoryGroupName] varchar(255),
    CONSTRAINT [PK_dimCategoryGroup] PRIMARY KEY ([categoryGroupId])
);

