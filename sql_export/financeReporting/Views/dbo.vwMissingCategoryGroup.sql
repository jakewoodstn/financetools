-- Exported: 2026-06-21T21:55:42.297944+00:00
-- Schema:   dbo
-- Object:   vwMissingCategoryGroup
-- Type:     VIEW
-- Created:  2019-05-06 16:22:15.957000
-- Modified: 2019-05-06 17:03:59.253000


CREATE VIEW vwMissingCategoryGroup AS 
  SELECT groupName categoryGroupName FROM Finances.dbo.spendingCategoryGroup cg
    EXCEPT
  SELECT cg.categoryGroupName FROM dimCategoryGroup cg
