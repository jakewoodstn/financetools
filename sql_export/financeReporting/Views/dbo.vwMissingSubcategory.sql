-- Exported: 2026-06-21T21:55:42.312038+00:00
-- Schema:   dbo
-- Object:   vwMissingSubcategory
-- Type:     VIEW
-- Created:  2019-05-06 16:22:52.660000
-- Modified: 2019-05-06 17:03:59.333000



CREATE VIEW vwMissingSubcategory AS 
  SELECT dc.categoryId, sq2.subcategoryName FROM 
  (SELECT categoryName, subcategoryName FROM 
    (
      SELECT DISTINCT LEFT(c.categoryName,CHARINDEX('-',c.categoryName)-2) categoryName, RIGHT(c.categoryName,LEN(c.categoryName) - CHARINDEX('-',categoryName)-1) subcategoryName FROM finances.dbo.spendingCategories c  WHERE CHARINDEX('-',categoryName) >0
      
    ) sq
    EXCEPT 
  SELECT categoryName, subcategoryName FROM dimSubcategory sc INNER JOIN dimCategory c ON sc.categoryId = c.categoryId) sq2
   INNER JOIN dimCategory dc ON sq2.categoryName=dc.categoryName
