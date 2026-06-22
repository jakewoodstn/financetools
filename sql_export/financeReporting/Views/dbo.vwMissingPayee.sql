-- Exported: 2026-06-21T21:55:42.311520+00:00
-- Schema:   dbo
-- Object:   vwMissingPayee
-- Type:     VIEW
-- Created:  2019-05-06 16:20:27.267000
-- Modified: 2019-05-06 17:03:59.247000


CREATE VIEW vwMissingPayee AS 
   SELECT description payeeName FROM finances.dbo.bankTransaction t
    EXCEPT
   SELECT payeeName FROM dimPayee p
