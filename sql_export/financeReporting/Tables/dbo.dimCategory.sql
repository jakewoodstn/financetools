-- Exported: 2026-06-21T21:55:42.571645+00:00
-- Schema:   dbo
-- Table:    dimCategory

CREATE TABLE [dbo].[dimCategory] (
    [categoryId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [categoryGroupId] int NOT NULL,
    [categoryName] varchar(255),
    CONSTRAINT [PK_dimCategory] PRIMARY KEY ([categoryId])
);

ALTER TABLE [dbo].[dimCategory] ADD CONSTRAINT [FK__dimCatego__categ__15A53433] FOREIGN KEY ([categoryGroupId]) REFERENCES [dbo].[dimCategoryGroup] ([categoryGroupId]);
