-- Exported: 2026-06-21T21:55:42.293929+00:00
-- Schema:   dbo
-- Object:   loadSubcategory
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2019-07-12 14:28:30.937000
-- Modified: 2020-01-26 22:02:53.990000

CREATE PROCEDURE dbo.loadSubcategory
AS
BEGIN

  INSERT INTO dimSubcategory (categoryId, subcategoryName)
    SELECT
      categoryId
     ,subcategoryName
    FROM vwMissingSubcategory

  INSERT INTO dimSubcategory (categoryId, subcategoryName)
    SELECT
      categoryId
     ,''
    FROM vwDescriptionCategory
    WHERE subCategoryName IS NULL
END
