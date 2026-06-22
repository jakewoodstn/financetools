-- Exported: 2026-06-21T21:55:42.297159+00:00
-- Schema:   dbo
-- Object:   vwMissingAccount
-- Type:     VIEW
-- Created:  2019-05-06 16:04:31.450000
-- Modified: 2019-05-06 17:03:59.137000



CREATE VIEW vwMissingAccount AS 
  SELECT accountId, accountName FROM Finances.dbo.account a
    EXCEPT 
  SELECT accountId, accountName FROM dimAccount
