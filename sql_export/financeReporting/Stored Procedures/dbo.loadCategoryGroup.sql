-- Exported: 2026-06-21T21:55:42.269119+00:00
-- Schema:   dbo
-- Object:   loadCategoryGroup
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2019-07-12 14:28:10.673000
-- Modified: 2019-07-12 14:30:30.937000


CREATE PROCEDURE loadCategoryGroup
AS
BEGIN
  INSERT INTO dimCategoryGroup (categoryGroupName)
    SELECT
      categoryGroupName
    FROM vwMissingCategoryGroup
END
