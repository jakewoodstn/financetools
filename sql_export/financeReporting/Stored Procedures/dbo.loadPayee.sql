-- Exported: 2026-06-21T21:55:42.293404+00:00
-- Schema:   dbo
-- Object:   loadPayee
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2019-07-12 14:28:10.667000
-- Modified: 2019-07-12 14:30:30.927000


CREATE PROCEDURE loadPayee
AS
BEGIN

  INSERT INTO dimPayee (payeeName)
    SELECT
      payeename
    FROM vwMissingPayee
END
