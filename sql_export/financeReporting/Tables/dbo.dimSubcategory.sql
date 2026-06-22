-- Exported: 2026-06-21T21:55:42.574459+00:00
-- Schema:   dbo
-- Table:    dimSubcategory

CREATE TABLE [dbo].[dimSubcategory] (
    [subcategoryId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [categoryId] int NOT NULL,
    [subcategoryName] varchar(255),
    CONSTRAINT [PK_dimSubcategory] PRIMARY KEY ([subcategoryId])
);

ALTER TABLE [dbo].[dimSubcategory] ADD CONSTRAINT [FK__dimSubcat__categ__1881A0DE] FOREIGN KEY ([categoryId]) REFERENCES [dbo].[dimCategory] ([categoryId]);
