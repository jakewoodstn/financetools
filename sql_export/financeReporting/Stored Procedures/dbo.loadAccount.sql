-- Exported: 2026-06-21T21:55:42.267336+00:00
-- Schema:   dbo
-- Object:   loadAccount
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2019-07-12 14:28:10.617000
-- Modified: 2019-07-12 14:30:30.897000



CREATE PROCEDURE loadAccount
AS
BEGIN

  INSERT INTO dimAccount (accountId, accountName)
    SELECT
      *
    FROM vwMissingAccount;
END
