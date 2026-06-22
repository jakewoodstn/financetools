-- Exported: 2026-06-21T21:55:42.297699+00:00
-- Schema:   dbo
-- Object:   vwMissingCategory
-- Type:     VIEW
-- Created:  2019-05-06 16:22:49.317000
-- Modified: 2019-05-06 17:03:59.310000


CREATE VIEW vwMissingCategory AS 
  SELECT cg.categoryGroupId, sq2.categoryName FROM 
  (SELECT categoryGroupName, categoryName FROM 
    (
      SELECT DISTINCT cg.groupName categoryGroupName, LEFT(c.categoryName,CHARINDEX('-',c.categoryName)-2) categoryName FROM finances.dbo.spendingCategories c INNER JOIN finances.dbo.spendingCategoryGroup cg ON c.groupID = cg.groupID WHERE CHARINDEX('-',categoryName) >0
      UNION SELECT DISTINCT cg.groupName categoryGroupName, c.categoryName FROM finances.dbo.spendingCategories c INNER JOIN finances.dbo.spendingCategoryGroup cg ON c.groupID = cg.groupID WHERE CHARINDEX('-',categoryName) =0
    ) sq
    EXCEPT 
  SELECT categoryGroupName, categoryName FROM dimCategory c INNER JOIN dimCategoryGroup cg ON c.categoryGroupId = cg.categoryGroupId )sq2
  INNER JOIN dimCategoryGroup cg ON sq2.categoryGroupName = cg.categoryGroupName
