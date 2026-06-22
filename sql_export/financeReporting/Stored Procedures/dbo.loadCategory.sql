-- Exported: 2026-06-21T21:55:42.268772+00:00
-- Schema:   dbo
-- Object:   loadCategory
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2019-07-12 14:28:30.933000
-- Modified: 2019-07-12 14:30:30.940000


CREATE PROCEDURE loadCategory
AS
BEGIN

  INSERT INTO dimCategory (categoryGroupId, categoryName)
    SELECT
      categoryGroupId
     ,categoryName
    FROM vwMissingCategory
END
