-- Exported: 2026-06-21T21:55:41.638311+00:00
-- Schema:   dbo
-- Table:    spendingCategories

CREATE TABLE [dbo].[spendingCategories] (
    [categoryId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [categoryName] varchar(200),
    [groupID] int NOT NULL DEFAULT ((0)),
    [ts] timestamp NOT NULL,
    CONSTRAINT [PK_spendingCategories] PRIMARY KEY ([categoryId])
);

ALTER TABLE [dbo].[spendingCategories] ADD CONSTRAINT [FK__spendingC__group__10966653] FOREIGN KEY ([groupID]) REFERENCES [dbo].[spendingCategoryGroup] ([groupID]);
