-- Exported: 2026-06-21T21:55:42.295545+00:00
-- Schema:   dbo
-- Object:   vwDescriptionCategory
-- Type:     VIEW
-- Created:  2020-01-26 22:02:48.970000
-- Modified: 2020-01-26 22:02:48.970000



CREATE   VIEW dbo.vwDescriptionCategory
  AS
  SELECT cg.categoryGroupId
        ,c.categoryId
        ,s.subcategoryId
        ,cg.categoryGroupName
        ,c.categoryName
        ,s.subcategoryName 
  FROM dimCategoryGroup cg 
    INNER JOIN dimCategory c ON cg.categoryGroupId = c.categoryGroupId 
    LEFT JOIN dimSubcategory s ON c.categoryId = s.categoryId
